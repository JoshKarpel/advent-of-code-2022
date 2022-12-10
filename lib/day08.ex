defmodule Day08 do
  def solve do
    heights =
      File.stream!("data/day_08.txt")
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.map(&(&1 |> String.codepoints() |> Enum.map(fn h -> String.to_integer(h) end)))
      |> Enum.with_index(fn line, y ->
        line |> Enum.with_index(fn h, x -> {{x, y}, h} end)
      end)
      |> List.flatten()
      |> Map.new(& &1)

    {x_max, y_max} = heights |> Map.keys() |> Enum.max()

    left_rows =
      0..y_max
      |> Enum.map(fn y ->
        0..x_max
        |> Enum.map(&{&1, y})
        |> take_visible(fn p -> Map.get(heights, p) end)
      end)

    down_cols =
      0..x_max
      |> Enum.map(fn x ->
        0..y_max
        |> Enum.map(&{x, &1})
        |> take_visible(fn p -> Map.get(heights, p) end)
      end)

    right_rows =
      0..y_max
      |> Enum.map(fn y ->
        0..x_max
        |> Enum.reverse()
        |> Enum.map(&{&1, y})
        |> take_visible(fn p -> Map.get(heights, p) end)
      end)

    up_cols =
      0..x_max
      |> Enum.map(fn x ->
        0..y_max
        |> Enum.reverse()
        |> Enum.map(&{x, &1})
        |> take_visible(fn p -> Map.get(heights, p) end)
      end)

    visible =
      (left_rows ++ down_cols ++ right_rows ++ up_cols)
      |> List.flatten()
      |> MapSet.new()
      |> MapSet.size()

    {visible, 0}
  end

  def take_visible(enumerable, by) do
    {_, visible} =
      enumerable
      |> Enum.reduce({nil, []}, fn
        e, {_, []} ->
          {by.(e), [e]}

        e, {tallest, visible} ->
          h = by.(e)
          new_tallest = Enum.max([tallest, h])

          if h > tallest do
            {new_tallest, [e | visible]}
          else
            {new_tallest, visible}
          end
      end)

    visible
  end
end
