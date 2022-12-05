defmodule Day05 do
  def solve do
    [raw_initial, _, raw_moves] =
      File.stream!("data/day_05.txt")
      |> Enum.map(&String.trim_trailing(&1))
      |> Enum.chunk_by(&(&1 == ""))

    initial_stacks =
      raw_initial
      |> Enum.map(&parse_layer/1)
      |> build_initial_stacks

    moves =
      raw_moves
      |> Enum.map(&Regex.run(~r/move (\d+) from (\d+) to (\d+)/, &1, capture: :all_but_first))
      |> Enum.map(fn i -> Enum.map(i, &String.to_integer/1) end)

    p1 =
      moves
      |> Enum.reduce(
        initial_stacks,
        fn [num, from, to], outer_acc ->
          Enum.reduce(1..num, outer_acc, fn _, inner_acc ->
            [f | new_from] = Map.get(inner_acc, from)
            new_to = [f | Map.get(inner_acc, to)]

            Map.merge(inner_acc, %{to => new_to, from => new_from})
          end)
        end
      )
      |> top_crates

    p2 =
      moves
      |> Enum.reduce(
        initial_stacks,
        fn [num, from, to], stacks ->
          {moving, new_from} = Enum.split(Map.get(stacks, from), num)
          new_to = moving ++ Map.get(stacks, to)

          Map.merge(stacks, %{to => new_to, from => new_from})
        end
      )
      |> top_crates

    {p1, p2}
  end

  def parse_layer(layer) do
    Regex.scan(~r/\[(\w)\]/, layer, capture: :all_but_first, return: :index)
    |> Enum.map(&List.first/1)
    |> Enum.map(fn {idx, _} -> {div(idx - 1, 4) + 1, String.at(layer, idx)} end)
    |> Enum.into(%{})
  end

  def build_initial_stacks(layers) do
    layers
    # so that the top of the stack is the front of the list
    |> Enum.reverse()
    |> Enum.reduce(
      %{},
      fn layer, stacks ->
        layer
        |> Enum.reduce(
          stacks,
          fn {k, v}, s ->
            Map.update(s, k, [v], &[v | &1])
          end
        )
      end
    )
  end

  def top_crates(stacks) do
    stacks
    |> Enum.map(fn {_, v} -> List.first(v) end)
    |> Enum.join("")
  end
end
