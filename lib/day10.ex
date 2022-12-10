defmodule Day10 do
  def solve do
    {_, _, signal} =
      File.stream!("data/day_10.txt")
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.reduce({0, 1, 0}, fn
        instruction, {cycle, x, signal} ->
          {new_cycle, new_x} =
            case instruction |> String.split(" ") do
              ["noop"] ->
                {cycle + 1, x}

              ["addx", dx] ->
                {cycle + 2, x + String.to_integer(dx)}
            end

          cycle_hit =
            cycle..new_cycle |> Enum.drop(1) |> Enum.find(0, fn c -> rem(c - 20, 40) == 0 end)

          signal = signal + x * cycle_hit

          {new_cycle, new_x, signal}
      end)

    {signal, 0}
  end
end
