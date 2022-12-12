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

    edges =
      heights
      |> Enum.reduce(%{}, fn {{x, y}, h}, outer_acc ->
        [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
        |> Enum.reduce(outer_acc, fn {dx, dy}, inner_acc ->
          test = {x + dx, y + dy}

          case Map.get(heights, test) do
            other_h when other_h <= h + 1 ->
              inner_acc |> Map.update({x, y}, [test], fn others -> [test | others] end)

            _ ->
              inner_acc
          end
        end)
      end)

    paths = shortest_paths(edges, MapSet.new([start]), %{start => 0}, MapSet.new([start]))

    {paths |> Map.get(target), 0}
  end

  @infinity 1_000_000

  def shortest_paths(edges, frontier, paths, visited) do
    sorted_frontier =
      frontier
      |> Enum.sort_by(fn f -> Map.get(paths, f, @infinity) end)

    case sorted_frontier do
      [] ->
        paths

      [head | tail] ->
        new_visited = visited |> MapSet.put(head)
        neighbours = Map.get(edges, head, [])

        new_frontier =
          MapSet.new(tail ++ (neighbours |> Enum.reject(&Enum.member?(new_visited, &1))))

        cost_to_neighbours = Map.get(paths, head) + 1

        new_paths =
          neighbours
          |> Enum.reduce(
            paths,
            fn n, paths ->
              paths
              |> Map.update(n, cost_to_neighbours, fn prev ->
                Enum.min([prev, cost_to_neighbours])
              end)
            end
          )

        shortest_paths(edges, new_frontier, new_paths, new_visited)
    end
  end
end
