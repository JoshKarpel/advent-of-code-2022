defmodule Day16 do
  @minutes 30

  def solve do
    valves_flows_tunnels =
      File.stream!("data/day_16.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(
        &Regex.run(~r/Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? ([\w\s,]+)/, &1,
          capture: :all_but_first
        )
      )
      |> Enum.map(fn [valve, flow, tunnels] ->
        {valve, {String.to_integer(flow), String.split(tunnels, ", ")}}
      end)
      |> Map.new()

    flows =
      valves_flows_tunnels
      |> Enum.map(fn {v, {f, t}} -> {v, f} end)
      |> Map.new()
      |> IO.inspect(label: "flows")

    edges = valves_flows_tunnels |> collapse_edges |> IO.inspect(label: "collapsed edges")

    %{"DD" => 2, "BB" => 5, "JJ" => 9, "HH" => 17, "EE" => 21, "CC" => 24}
    |> score_path(flows)
    |> IO.inspect(label: "test score")

    p1 =
      find_paths([{"AA", 0}], edges)
      |> Enum.map(fn path -> score_path(path, flows) end)
      |> Enum.max()
      |> IO.inspect()

    {p1, 0}
  end

  def find_paths([{head, minute} | rest] = path, edges) do
    visited = path |> Enum.map(fn {p, _} -> p end) |> MapSet.new()

    unvisited =
      edges
      |> Map.keys()
      |> MapSet.new()
      |> MapSet.difference(visited)

    cond do
      # still have time, but nowhere else to go
      Enum.count(unvisited) == 0 ->
        [path]

      true ->
        unvisited
        |> Enum.flat_map(fn u ->
          new_minute = minute + 1 + (edges |> Map.get(head) |> Map.get(u))
          new_path = [{u, new_minute} | path]

          cond do
            new_minute > @minutes -> [path]
            true -> find_paths(new_path, edges)
          end
        end)
    end
  end

  def score_path(path, flows) do
    path
    |> Enum.map(fn {valve, minute} ->
      Map.get(flows, valve) * (@minutes - minute)
    end)
    |> Enum.sum()
  end

  def collapse_edges(valves_flows_tunnels) do
    edges = valves_flows_tunnels |> Enum.map(fn {v, {_, t}} -> {v, t} end) |> Map.new()

    has_flow =
      valves_flows_tunnels
      |> Enum.map(fn {v, {f, _}} -> {v, f} end)
      |> Enum.filter(fn {v, f} -> f > 0 or v == "AA" end)
      |> Enum.map(fn {v, _} -> v end)
      |> MapSet.new()

    has_flow
    |> Enum.map(fn v ->
      {v,
       shortest_paths(edges, v)
       |> Enum.filter(fn {target, _} ->
         Enum.member?(has_flow, target) and v != target
       end)
       |> Map.new()}
    end)
    |> Map.new()
  end

  def shortest_paths(edges, start) do
    _shortest_paths(edges, MapSet.new([start]), %{start => 0}, MapSet.new())
  end

  def _shortest_paths(edges, frontier, paths, visited) do
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

        _shortest_paths(edges, new_frontier, new_paths, new_visited)
    end
  end
end
