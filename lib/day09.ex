defmodule Day09 do
  def solve do
    {_, _, visited} =
      File.stream!("data/day_09.txt")
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.flat_map(fn instruction ->
        [dir, dist] = instruction |> String.split(" ")
        d = dist |> String.to_integer()

        1..d |> Enum.map(fn _ -> dir end)
      end)
      |> IO.inspect()
      |> Enum.reduce({{0, 0}, {0, 0}, MapSet.new([{0, 0}])}, fn dir,
                                                                {{h_x, h_y}, {t_x, t_y}, visited} ->
        IO.inspect(dir)

        {new_h_x, new_h_y} =
          case dir do
            "L" -> {h_x - 1, h_y}
            "R" -> {h_x + 1, h_y}
            "U" -> {h_x, h_y + 1}
            "D" -> {h_x, h_y - 1}
          end

        new_t =
          case {new_h_x - t_x, new_h_y - t_y} do
            {x, y} when abs(x) <= 1 and abs(y) <= 1 ->
              {t_x, t_y}

            {x, 0} ->
              {t_x + sign(x), t_y}

            {0, y} ->
              {t_x, t_y + sign(y)}

            {x, y} when abs(y) == 1 ->
              {t_x + sign(x), t_y + sign(y)}

            {x, y} when abs(x) == 1 ->
              {t_x + sign(x), t_y + sign(y)}
          end

        {{new_h_x, new_h_y}, new_t, visited |> MapSet.put(new_t)} |> IO.inspect()
      end)

    {visited |> MapSet.size(), 0}
  end

  def sign(x) do
    div(abs(x), x)
  end
end
