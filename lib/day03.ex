defmodule Day03 do
  def solve do
    rounds =
      File.stream!("data/day_03.txt")
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&halves/1)
      |> IO.inspect()
      |> Enum.map(fn {l, r} ->
        MapSet.intersection(MapSet.new(to_charlist(l)), MapSet.new(to_charlist(r)))
      end)
      |> IO.inspect()
      |> Enum.map(&List.first(MapSet.to_list(&1)))
      |> IO.inspect()
      |> Enum.map(&priority/1)
      |> IO.inspect()
      |> Enum.sum()

    {rounds, 0}
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
