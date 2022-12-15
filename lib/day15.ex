defmodule Day15 do
  @y 2_000_000

  def solve do
    sensors_and_beacons =
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

    sensor_to_distance =
      sensors_and_beacons
      |> Enum.map(fn {s, b} -> {s, manhattan_distance(s, b)} end)
      |> Map.new()
      |> IO.inspect()

    sensors = sensors_and_beacons |> Enum.map(fn {s, _} -> s end) |> MapSet.new()
    beacons = sensors_and_beacons |> Enum.map(fn {_, b} -> b end) |> MapSet.new()

    p1 =
      sensors_and_beacons
      |> Enum.map(fn {{s_x, s_y} = s, b} ->
        d = manhattan_distance(s, b)
        IO.inspect({s, b, d})

        dist_to_y = manhattan_distance(s, {s_x, @y})

        if dist_to_y >= 0 do
          remaining_dist = d - dist_to_y
          -remaining_dist..remaining_dist |> Enum.map(fn r -> {s_x + r, @y} end)
        else
          []
        end
      end)
      |> Enum.concat()
      |> MapSet.new()
      |> MapSet.difference(beacons)
      |> IO.inspect()
      |> Enum.count()

    {p1, 0}
  end

  def manhattan_distance({a_x, a_y}, {b_x, b_y}) do
    abs(a_x - b_x) + abs(a_y - b_y)
  end
end
