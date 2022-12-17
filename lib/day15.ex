defmodule Day15 do
  @y 10

  @lower_bound 0
  @upper_bound 20

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

    sensor_to_distance =
      sensors_and_beacons
      |> Enum.map(fn {s, b} -> {s, manhattan_distance(s, b)} end)
      |> Map.new()

    sensors = sensors_and_beacons |> Enum.map(fn {s, _} -> s end) |> MapSet.new()

    beacons =
      sensors_and_beacons
      |> Enum.map(fn {_, b} -> b end)
      |> MapSet.new()
      |> Enum.count()

    p1 =
      (sensors_and_beacons
       |> outlawed_on_fixed_y_line(@y)
       |> IO.inspect()
       |> Enum.map(&Enum.count(&1))
       |> Enum.sum()) - count_beacons_at_fixed_y(sensors_and_beacons, @y)

    #    p2 =
    #      @lower_bound..@upper_bound
    #      |> Enum.map(fn y ->
    #        IO.puts("\ny=#{y}")
    #        outlawed_on_fixed_y_line(sensors_and_beacons, y) |> IO.inspect()
    #      end)
    #      |> IO.inspect()

    p2 = 0
    {p1, p2}
  end

  def manhattan_distance({a_x, a_y}, {b_x, b_y}) do
    abs(a_x - b_x) + abs(a_y - b_y)
  end

  def outlawed_on_fixed_y_line(sensor_and_beacons, fixed_y) do
    sensor_and_beacons
    |> Enum.flat_map(fn {{s_x, s_y} = s, b} ->
      dist_to_nearest_beacon = manhattan_distance(s, b)

      dist_to_fixed_y_line = manhattan_distance(s, {s_x, fixed_y})
      IO.puts("")
      IO.inspect({s, b, dist_to_nearest_beacon, dist_to_fixed_y_line})

      if dist_to_nearest_beacon >= dist_to_fixed_y_line do
        remaining_dist =
          (dist_to_nearest_beacon - dist_to_fixed_y_line) |> IO.inspect(label: "remaining dist")

        [(s_x - remaining_dist)..(s_x + remaining_dist)] |> IO.inspect()
      else
        []
      end
    end)
    |> Enum.sort()
    |> IO.inspect()
    |> Enum.reduce([], fn
      next, [previous | rest] ->
        IO.inspect({next, previous, rest})
        merge_adjacent_ranges(previous, next) ++ rest

      next, [] ->
        [next]
    end)
  end

  def merge_adjacent_ranges(a, b) do
    # a and b must be sorted, which implies that a.first <= b.first
    cond do
      a.last < b.first ->
        [b, a]

      a.last >= b.first ->
        [a.first..max(a.last, b.last)]
    end
  end

  def count_beacons_at_fixed_y(sensors_and_beacons, fixed_y) do
    sensors_and_beacons
    |> Enum.map(fn {_, b} -> b end)
    |> MapSet.new()
    |> Enum.filter(fn {_, b_y} -> b_y == fixed_y end)
    |> Enum.count()
  end
end
