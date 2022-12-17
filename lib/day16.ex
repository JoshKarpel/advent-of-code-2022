defmodule Day16 do
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
        {valve, String.to_integer(flow), String.split(tunnels, ", ")}
      end)
      |> IO.inspect()

    {0, 0}
  end
end
