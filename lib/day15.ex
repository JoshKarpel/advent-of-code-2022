defmodule Day15 do
  def solve do
    File.stream!("data/day_15.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line ->
      Regex.run(
        ~r/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/,
        line,
        capture: :all_but_first
      )
      |> Enum.map(&String.to_integer/1)
      |> then(fn [s_x, s_y, b_x, b_y] -> {{s_x, s_y}, {b_x, b_y}} end)
    end)
    |> IO.inspect()

    {0, 0}
  end

  def manhattan_distance({a_x, a_y}, {b_x, b_y}) do
    abs(a_x - b_x) + abs(a_y - b_y)
  end
end
