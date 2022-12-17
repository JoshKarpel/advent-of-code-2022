defmodule Day15 do
  @y 2_000_000

  @lower_bound 0
  @upper_bound 4_000_000

  @multiplier 4_000_000

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
        |> then(fn [s_x, s_y, b_x, b_y] ->
          {{s_x, s_y}, {b_x, b_y}, manhattan_distance({s_x, s_y}, {b_x, b_y})}
        end)
      end)

    p1 =
      (sensors_and_beacons
       |> outlawed_on_fixed_y_line(@y)
       |> Enum.map(&Enum.count(&1))
       |> Enum.sum()) - count_beacons_at_fixed_y(sensors_and_beacons, @y)

    p2 =
      @lower_bound..@upper_bound
      |> Stream.map(fn y ->
        {y, outlawed_on_fixed_y_line(sensors_and_beacons, y)}
      end)
      |> Enum.find_value(fn
        {y, [a, _]} -> {a.last + 1, y}
        _ -> false
      end)
      |> then(fn {x, y} -> x * @multiplier + y end)

    {p1, p2}
  end

  def manhattan_distance({a_x, a_y}, {b_x, b_y}) do
    abs(a_x - b_x) + abs(a_y - b_y)
  end

  def outlawed_on_fixed_y_line(sensor_and_beacons, fixed_y) do
    sensor_and_beacons
    |> Enum.flat_map(fn {{s_x, _} = s, _, dist_to_nearest_beacon} ->
      dist_to_fixed_y_line = manhattan_distance(s, {s_x, fixed_y})

      remaining_dist = dist_to_nearest_beacon - dist_to_fixed_y_line

      if remaining_dist >= 0 do
        [(s_x - remaining_dist)..(s_x + remaining_dist)]
      else
        []
      end
    end)
    |> Enum.sort()
    |> Enum.reduce([], fn
      next, [previous | rest] ->
        merge_adjacent_ranges(previous, next) ++ rest

      next, [] ->
        [next]
    end)
    |> Enum.reverse()
  end

  def merge_adjacent_ranges(previous, next) do
    # previous and next must be pre-sorted, which implies that previous.first <= next.first

    # add 1 because ranges are inclusive; 1..4 and 5..8 should combine to 1..8 because the first range includes 4
    if previous.last + 1 >= next.first do
      [previous.first..max(previous.last, next.last)]
    else
      [next, previous]
    end
  end

  def count_beacons_at_fixed_y(sensors_and_beacons, fixed_y) do
    sensors_and_beacons
    |> Enum.map(fn {_, b, _} -> b end)
    |> MapSet.new()
    |> Enum.filter(fn {_, b_y} -> b_y == fixed_y end)
    |> Enum.count()
  end
end
