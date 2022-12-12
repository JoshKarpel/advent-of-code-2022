defmodule Day12 do
  def solve do
    {start, target, heights} =
      File.stream!("data/day_12.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.map(fn {h, x} -> {{x, y}, h} end)
      end)
      |> Enum.reduce({nil, nil, %{}}, fn {{x, y}, h}, {start, target, heights} ->
        case h do
          83 -> {{x, y}, target, heights |> Map.put({x, y}, 0)}
          69 -> {start, {x, y}, heights |> Map.put({x, y}, 25)}
          h when h >= 97 -> {start, target, heights |> Map.put({x, y}, h - 97)}
        end
      end)
      |> IO.inspect()

    edges =
      heights
      |> Enum.reduce(%{}, fn {{x, y}, h}, outer_acc ->
        [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
        |> Enum.reduce(outer_acc, fn {dx, dy}, inner_acc ->
          test = {x + dx, y + dy}

          case Map.get(heights, test) do
            other_h when other_h <= h + 1 ->
              inner_acc |> Map.update({x, y}, [], fn others -> [test | others] end)

            _ ->
              inner_acc
          end
        end)
      end)
      |> IO.inspect()

    {0, 0}
  end
end
