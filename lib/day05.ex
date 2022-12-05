defmodule Day05 do
  def solve do
    [initial, _, moves] =
      File.stream!("data/day_05.txt")
      |> Enum.map(&String.trim_trailing(&1))
      |> Enum.chunk_by(&(&1 == ""))

    initial
    |> Enum.map(&parse_layer/1)
    |> IO.inspect()
    |> Enum.reverse()
    |> initial_state
    |> IO.inspect()

    {0, 0}
  end

  def parse_layer(layer) do
    indices =
      Regex.scan(~r/\[(\w)\]/, layer, capture: :all_but_first, return: :index)
      |> Enum.map(&List.first/1)
      |> Enum.map(fn {idx, _} -> {div(idx - 1, 4) + 1, String.at(layer, idx)} end)
      |> Enum.into(%{})
  end

  def initial_state(layers) do
    inner_reducer = fn layer, stacks ->
      layer
      |> Enum.reduce(
        stacks,
        fn {k, v}, s ->
          Map.update(s, k, [v], &[v | &1])
        end
      )
    end

    layers
    |> Enum.reduce(
      %{},
      inner_reducer
    )
  end
end
