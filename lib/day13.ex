defmodule Day13 do
  def solve do
    p1 =
      File.stream!("data/day_13.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))
      |> Enum.map(fn pair ->
        pair
        |> Enum.map(fn packet ->
          {result, _} = Code.eval_string(packet)
          result
        end)
      end)
      |> Enum.with_index(1)
      |> Enum.filter(fn {lr, idx} ->
        IO.puts("")
        IO.puts(idx)
        right_order?(lr) |> IO.inspect()
      end)
      #      |> IO.inspect(charlists: :as_lists)
      |> Enum.map(fn {_, idx} -> idx end)
      |> Enum.sum()

    {p1, 0}
  end

  def right_order?([left, right]) do
    IO.inspect({left, right}, charlists: :as_lists)

    case {left |> List.pop_at(0), right |> List.pop_at(0)} do
      {{nil, []}, {nil, []}} ->
        :neither |> IO.inspect(label: "both empty")

      {{nil, []}, _} ->
        true |> IO.inspect(label: "left ran out")

      {_, {nil, []}} ->
        false |> IO.inspect(label: "right ran out")

      {{l, rest_l}, {r, rest_r}} when is_integer(l) and is_integer(r) and l > r ->
        false |> IO.inspect(label: "wrong sorted ints")

      {{l, rest_l}, {r, rest_r}} when is_integer(l) and is_integer(r) and l < r ->
        true |> IO.inspect(label: "right sorted ints")

      {{l, rest_l}, {r, rest_r}} when is_integer(l) and is_integer(r) and l == r ->
        right_order?([rest_l, rest_r])

      {{l, rest_l}, {r, rest_r}} when is_list(l) and is_list(r) ->
        case {right_order?([l, r]), right_order?([rest_l, rest_r])} do
          {true, _} -> true
          {false, _} -> false
          {:neither, r} -> r
        end

      {{l, rest_l}, {r, rest_r}} when is_integer(l) and is_list(r) ->
        case {right_order?([[l], r]), right_order?([rest_l, rest_r])} do
          {true, _} -> true
          {false, _} -> false
          {:neither, rest} -> rest
        end

      {{l, rest_l}, {r, rest_r}} when is_list(l) and is_integer(r) ->
        case {right_order?([l, [r]]), right_order?([rest_l, rest_r])} do
          {true, _} -> true
          {false, _} -> false
          {:neither, rest} -> rest
        end
    end
  end
end
