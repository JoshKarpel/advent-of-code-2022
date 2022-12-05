defmodule Day05 do
  def solve do
    [initial, _, moves] =
      File.stream!("data/day_05.txt")
      |> Enum.map(&String.trim_trailing(&1))
      |> Enum.chunk_by(&(&1 == ""))

    initial_stacks =
      initial
      |> Enum.map(&parse_layer/1)
      |> Enum.reverse()
      |> initial_state

    p1 =
      moves
      |> Enum.map(&Regex.run(~r/move (\d+) from (\d+) to (\d+)/, &1, capture: :all_but_first))
      |> Enum.map(fn i -> Enum.map(i, &String.to_integer/1) end)
      |> Enum.reduce(
        initial_stacks,
        fn [num, from, to], stacks ->
          Enum.reduce(1..num, stacks, fn n, acc ->
            {new_f, new_t} =
              case {Map.get(acc, from), Map.get(acc, to)} do
                {[f | nf], nt} -> {nf, [f | nt]}
              end

            acc
            |> Map.put(to, new_t)
            |> Map.put(from, new_f)
          end)
        end
      )
      |> Enum.map(fn {_, v} -> List.first(v) end)
      |> Enum.join("")

    p2 =
      moves
      |> Enum.map(&Regex.run(~r/move (\d+) from (\d+) to (\d+)/, &1, capture: :all_but_first))
      |> Enum.map(fn i -> Enum.map(i, &String.to_integer/1) end)
      |> Enum.reduce(
        initial_stacks,
        fn [num, from, to], acc ->
          {moving, new_f} = Enum.split(Map.get(acc, from), num)
          new_t = moving ++ Map.get(acc, to)

          acc
          |> Map.put(to, new_t)
          |> Map.put(from, new_f)
        end
      )
      |> Enum.map(fn {_, v} -> List.first(v) end)
      |> Enum.join("")

    {p1, p2}
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
