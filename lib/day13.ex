defmodule Day13 do
  def solve do
    packets =
      File.stream!("data/day_13.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&Jason.decode!/1)

    p1 =
      packets
      |> Enum.chunk_every(2)
      |> Enum.with_index(1)
      |> Enum.flat_map(fn {[l, r], idx} ->
        case right_order?(l, r) do
          true -> [idx]
          false -> []
        end
      end)
      |> Enum.sum()

    sorted =
      ([[[2]], [[6]]] ++ packets)
      |> Enum.sort(&right_order?/2)

    p2 =
      (Enum.find_index(sorted, &(&1 == [[2]])) + 1) *
        (Enum.find_index(sorted, &(&1 == [[6]])) + 1)

    {p1, p2}
  end

  def right_order?(left, right) do
    case {left |> List.pop_at(0), right |> List.pop_at(0)} do
      {{nil, []}, {nil, []}} ->
        :neither

      {{nil, []}, _} ->
        true

      {_, {nil, []}} ->
        false

      {{l, rest_l}, {r, rest_r}} when is_integer(l) and is_integer(r) ->
        cond do
          l > r -> false
          l < r -> true
          l == r -> right_order?(rest_l, rest_r)
        end

      {{l, rest_l}, {r, rest_r}} when is_list(l) and is_list(r) ->
        case right_order?(l, r) do
          :neither -> right_order?(rest_l, rest_r)
          bool -> bool
        end

      {{l, rest_l}, {r, rest_r}} when is_integer(l) and is_list(r) ->
        case right_order?([l], r) do
          :neither -> right_order?(rest_l, rest_r)
          bool -> bool
        end

      {{l, rest_l}, {r, rest_r}} when is_list(l) and is_integer(r) ->
        case right_order?(l, [r]) do
          :neither -> right_order?(rest_l, rest_r)
          bool -> bool
        end
    end
  end
end
