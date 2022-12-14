defmodule Day14 do
  @max_x 1_000_000

  def solve do
    map =
      File.stream!("data/day_14.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn line ->
        line
        |> String.split(" -> ")
        |> Enum.map(fn coords ->
          coords |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
        end)
      end)
      |> Enum.map(&expand_path/1)
      |> Enum.concat()
      |> Enum.map(fn coord -> {coord, :rock} end)
      |> Map.new()

    last_rock_y = map |> max_y

    p1 =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.reduce_while(map, fn s, map ->
        case fall({500, 0}, map, last_rock_y) do
          # indexed zero, but s is the piece of sand that *fell*, so that handles the offset
          :halt -> {:halt, s}
          new_map -> {:cont, new_map}
        end
      end)

    map_with_floor =
      Map.merge(
        map,
        -@max_x..@max_x |> Enum.map(fn x -> {{x, last_rock_y + 2}, :rock} end) |> Map.new()
      )

    last_rock_y_for_map_with_floor = map_with_floor |> max_y

    p2 =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.reduce_while(map_with_floor, fn s, map ->
        case fall({500, 0}, map, last_rock_y_for_map_with_floor) do
          # indexed zero, but s is the piece of sand that *fell*, so that handles the offset
          :halt -> {:halt, s}
          new_map -> {:cont, new_map}
        end
      end)

    {p1, p2}
  end

  def expand_path(path) do
    path
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [{p_x, p_y}, {n_x, n_y}] ->
      cond do
        p_x == n_x -> p_y..n_y |> Enum.map(fn y -> {p_x, y} end)
        p_y == n_y -> p_x..n_x |> Enum.map(fn x -> {x, p_y} end)
      end
    end)
    |> Enum.concat()
  end

  def fall({x, y}, map, last_rock_y) do
    cond do
      # we're about to fall off the bottom
      y == last_rock_y ->
        :halt

      # the current space is itself blocked
      Map.get(map, {x, y}) ->
        :halt

      is_nil(Map.get(map, {x, y + 1})) ->
        fall({x, y + 1}, map, last_rock_y)

      is_nil(Map.get(map, {x - 1, y + 1})) ->
        fall({x - 1, y + 1}, map, last_rock_y)

      is_nil(Map.get(map, {x + 1, y + 1})) ->
        fall({x + 1, y + 1}, map, last_rock_y)

      true ->
        map |> Map.put({x, y}, :sand)
    end
  end

  def max_y(map) do
    map |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.max()
  end
end
