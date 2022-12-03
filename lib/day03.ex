defmodule Day03 do
  def solve do
    rucksacks =
      File.stream!("data/day_03.txt")
      |> Enum.map(&String.trim(&1))

    part_1 =
      rucksacks
      |> Enum.map(&halves/1)
      |> Enum.map(&common_character/1)
      |> Enum.map(&priority/1)
      |> Enum.sum()

    part_2 =
      rucksacks
      |> Enum.chunk_every(3)
      |> Enum.map(&common_character/1)
      |> Enum.map(&priority/1)
      |> Enum.sum()

    {part_1, part_2}
  end

  def halves(s) do
    Tuple.to_list(String.split_at(s, div(String.length(s), 2)))
  end

  def charset(s) do
    MapSet.new(to_charlist(s))
  end

  def common_character(strings) do
    strings
    |> Enum.map(&charset/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.to_list()
    |> List.first()
  end

  def priority(c) do
    case c do
      c when c < 95 ->
        c - 65 + 27

      c when c >= 95 ->
        c - 97 + 1
    end
  end
end
