defmodule Day04 do
  def solve do
    pairs =
      File.stream!("data/day_04.txt")
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&Regex.run(~r/(\d+)\-(\d+),(\d+)\-(\d+)/, &1, capture: :all_but_first))
      |> Enum.map(fn nums -> Enum.map(nums, &String.to_integer/1) end)
      |> Enum.map(fn [a, b, c, d] -> {a..b, c..d} end)
      |> then(
        &{&1
         |> Enum.filter(fn {a, b} -> fully_contained?(a, b) or fully_contained?(b, a) end)
         |> Enum.count(),
         &1
         |> Enum.reject(fn {a, b} -> Range.disjoint?(a, b) end)
         |> Enum.count()}
      )
  end

  def fully_contained?(a, b) do
    Enum.member?(a, b.first) and Enum.member?(a, b.last)
  end
end
