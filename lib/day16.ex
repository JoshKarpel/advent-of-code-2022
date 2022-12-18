defmodule Day16 do
  @p1_max_minute 30
  @p2_max_minute 26

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
      |> Enum.map(fn {v, {f, _}} -> {v, f} end)
      |> Map.new()

    edges = valves_flows_tunnels |> collapse_edges

    p1 =
      find_paths([{"AA", 0}], edges, @p1_max_minute)
      |> Enum.map(fn path -> score_path(path, flows, @p1_max_minute) end)
      |> Enum.max()

    all_paths =
      find_paths([{"AA", 0}], edges, @p2_max_minute)
      |> Enum.map(fn path ->
        {path |> Map.keys() |> MapSet.new(), score_path(path, flows, @p2_max_minute)}
      end)

    num_paths = all_paths |> Enum.count()

    p2 =
      Stream.flat_map(all_paths |> Stream.with_index(), fn {me, idx} ->
        IO.puts("#{idx} / #{num_paths} | #{idx / num_paths}")
        Stream.map(all_paths, fn ele -> {me, ele} end)
      end)
      |> Stream.map(fn {{me_set, me_score}, {ele_set, ele_score}} ->
        if MapSet.disjoint?(me_set, ele_set) do
          me_score + ele_score
        else
          0
        end
      end)
      |> Enum.max()

    {p1, p2}
  end

  def find_paths([{head, minute} | _] = path, edges, max_minutes) do
    visited = path |> Enum.map(fn {p, _} -> p end) |> MapSet.new()

    unvisited =
      edges
      |> Map.keys()
      |> MapSet.new()
      |> MapSet.difference(visited)

    cond do
      # still have time, but nowhere else to go
      Enum.count(unvisited) == 0 ->
        [path |> Map.new() |> Map.drop(["AA"])]

      true ->
        unvisited
        |> Enum.flat_map(fn u ->
          new_minute = minute + 1 + (edges |> Map.get(head) |> Map.get(u))
          new_path = [{u, new_minute} | path]

          cond do
            new_minute >= max_minutes ->
              [path |> Map.new() |> Map.drop(["AA"])]

            true ->
              find_paths(new_path, edges, max_minutes) ++ [path |> Map.new() |> Map.drop(["AA"])]
          end
        end)
        |> Enum.uniq()
    end
  end

  def score_path(path, flows, max_minute) do
    path
    |> Enum.map(fn {valve, minute} ->
      Map.get(flows, valve) * (max_minute - minute)
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
       Day12.shortest_paths(edges, v)
       |> Enum.filter(fn {target, _} ->
         Enum.member?(has_flow, target) and v != target
       end)
       |> Map.new()}
    end)
    |> Map.new()
  end
end
