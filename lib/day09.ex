defmodule Day09 do
  def solve do
    instructions =
      File.stream!("data/day_09.txt")
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.flat_map(fn instruction ->
        [dir, dist] = instruction |> String.split(" ")
        d = dist |> String.to_integer()

        1..d |> Enum.map(fn _ -> dir end)
      end)

    {_, _, visited} =
      instructions
      |> Enum.reduce({{0, 0}, {0, 0}, MapSet.new([{0, 0}])}, fn dir, {h, t, visited} ->
        new_h = next_head_position(dir, h)

        new_t = next_tail_position(new_h, t)

        {new_h, new_t, visited |> MapSet.put(new_t)}
      end)

    {visited |> MapSet.size(), 0}
  end

  def next_head_position(dir, {h_x, h_y}) do
    case dir do
      "L" -> {h_x - 1, h_y}
      "R" -> {h_x + 1, h_y}
      "U" -> {h_x, h_y + 1}
      "D" -> {h_x, h_y - 1}
    end
  end

  def next_tail_position({new_h_x, new_h_y}, {t_x, t_y}) do
    case {new_h_x - t_x, new_h_y - t_y} do
      {x, y} when abs(x) <= 1 and abs(y) <= 1 ->
        {t_x, t_y}

      {x, y} ->
        {t_x + sign(x), t_y + sign(y)}
    end
  end

  def sign(x) do
    case x do
      0 -> 0
      x -> div(abs(x), x)
    end
  end
end
