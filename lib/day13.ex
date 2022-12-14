defmodule Day13 do
  def solve do
    packets =
      File.stream!("data/day_13.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))
      |> Enum.map(fn pair ->
        pair
        |> Enum.map(fn packet ->
          Jason.decode!(packet)
        end)
      end)

    sorted =
      [[[[2]], [[6]]] | packets]
      |> Enum.flat_map(& &1)
      |> Enum.sort(&right_order?/2)

    {packets
     |> Enum.with_index(1)
     |> Enum.filter(fn {[l, r], _} ->
       right_order?(l, r)
     end)
     |> Enum.map(fn {_, idx} -> idx end)
     |> Enum.sum(),
     (Enum.find_index(sorted, &(&1 == [[2]])) + 1) * (Enum.find_index(sorted, &(&1 == [[6]])) + 1)}
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
