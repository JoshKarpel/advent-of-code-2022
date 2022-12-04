defmodule Day04 do
  def solve do
    full_overlaps =
      File.stream!("data/day_04.txt")
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&Regex.run(~r/(\d+)\-(\d+),(\d+)\-(\d+)/, &1, capture: :all_but_first))
      |> Enum.map(fn nums -> Enum.map(nums, &String.to_integer/1) end)
      |> IO.inspect()
      |> Enum.map(fn [a, b, c, d] -> {a..b, c..d} end)
      |> IO.inspect()
      |> Enum.filter(fn {r1, r2} ->
        case {r1, r2} do
          {r1, r2} when r1.first >= r2.first and r1.last <= r2.last -> true
          {r1, r2} when r2.first >= r1.first and r2.last <= r1.last -> true
          _ -> false
        end
      end)
      |> Enum.count()

    {full_overlaps, 0}
  end
end
