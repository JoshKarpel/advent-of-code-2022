defmodule Day03 do
  def solve do
    rucksacks =
      File.stream!("data/day_03.txt")
      |> Enum.map(&String.trim(&1))

    priority_sum =
      rucksacks
      |> Enum.map(&halves/1)
      |> Enum.map(fn {l, r} ->
        MapSet.intersection(MapSet.new(to_charlist(l)), MapSet.new(to_charlist(r)))
      end)
      |> Enum.map(&List.first(MapSet.to_list(&1)))
      |> Enum.map(&priority/1)
      |> Enum.sum()

    badge_sum =
      rucksacks
      |> Enum.chunk_every(3)
      |> IO.inspect()
      |> Enum.map(fn sacks -> Enum.map(sacks, &MapSet.new(to_charlist(&1))) end)
      |> IO.inspect()
      |> Enum.map(fn sacks -> Enum.reduce(sacks, &MapSet.intersection/2) end)
      |> Enum.map(&List.first(MapSet.to_list(&1)))
      |> Enum.map(&priority/1)
      |> Enum.sum()

    {priority_sum, badge_sum}
  end

  def halves(s) do
    String.split_at(s, div(String.length(s), 2))
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
