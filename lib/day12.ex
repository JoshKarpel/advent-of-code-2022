defmodule Day12 do
  def solve do
    {start, target, heights} =
      File.stream!("data/day_12.txt")
      |> Enum.map(&String.trim/1)
      |> IO.inspect()
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.map(fn {h, x} -> {{x, y}, h} end)
      end)
      |> IO.inspect()
      |> Enum.reduce({nil, nil, %{}}, fn {{x, y}, h}, {start, target, heights} ->
        case h do
          83 -> {{x, y}, target, heights |> Map.put({x, y}, 0)}
          69 -> {start, {x, y}, heights |> Map.put({x, y}, 25)}
          h when h >= 97 -> {start, target, heights |> Map.put({x, y}, h - 97)}
        end
      end)
      |> IO.inspect()

    {0, 0}
  end
end
