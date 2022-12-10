defmodule Day10 do
  def solve do
    {_, _, signal, lit_pixels} =
      File.stream!("data/day_10.txt")
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.reduce({0, 1, 0, MapSet.new()}, fn
        instruction, {cycle, x, signal, lit_pixels} ->
          {new_cycle, new_x} =
            case instruction |> String.split(" ") do
              ["noop"] ->
                {cycle + 1, x}

              ["addx", dx] ->
                {cycle + 2, x + String.to_integer(dx)}
            end

          cycle_hit =
            cycle..new_cycle |> Enum.drop(1) |> Enum.find(0, fn c -> rem(c - 20, 40) == 0 end)

          lit_pixels =
            cycle..new_cycle
            |> Enum.drop(1)
            |> Enum.reduce(lit_pixels, fn c, pix ->
              # -1 to convert from cycle to position after wrapping onto the row
              if abs(rem(c, 40) - 1 - x) <= 1 do
                pix |> MapSet.put(c)
              else
                pix
              end
            end)

          signal = signal + x * cycle_hit

          {new_cycle, new_x, signal, lit_pixels}
      end)

    lit_pixels |> IO.inspect()

    image =
      "\n" <>
        (1..240
         |> Enum.map(fn c ->
           if MapSet.member?(lit_pixels, c) do
             "█"
           else
             " "
           end
         end)
         |> Enum.chunk_every(40)
         |> Enum.join("\n"))

    {signal, image}
  end
end
