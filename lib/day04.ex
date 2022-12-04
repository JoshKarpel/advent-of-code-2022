defmodule Day04 do
  def solve do
    pairs =
      File.stream!("data/day_04.txt")
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&Regex.run(~r/(\d+)\-(\d+),(\d+)\-(\d+)/, &1, capture: :all_but_first))
      |> Enum.map(fn nums -> Enum.map(nums, &String.to_integer/1) end)
      |> Enum.map(fn [a, b, c, d] -> {a..b, c..d} end)

    {pairs
     |> Enum.filter(fn {a, b} -> full_overlap?(a, b) end)
     |> Enum.count(),
     pairs
     |> Enum.reject(fn {a, b} -> Range.disjoint?(a, b) end)
     |> Enum.count()}
  end

  def full_overlap?(r1, r2) do
    (r1.first >= r2.first and r1.last <= r2.last) or (r2.first >= r1.first and r2.last <= r1.last)
  end
end
