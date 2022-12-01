defmodule Day01 do
  def solve do
    ordered_calorie_counts =
      File.stream!("data/day_01.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))
      |> Enum.map(fn nums -> Enum.map(nums, &String.to_integer/1) end)
      |> Enum.map(&Enum.sum/1)
      |> Enum.sort()
      |> Enum.reverse()

    [
      ordered_calorie_counts |> Enum.max(),
      ordered_calorie_counts
      |> Enum.take(3)
      |> Enum.sum()
    ]
  end
end
