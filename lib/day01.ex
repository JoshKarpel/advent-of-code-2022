defmodule Day01 do
  def solve do
    chunk_fun = fn e, acc ->
      case e do
        "" -> {:cont, acc, []}
        e -> {:cont, [e | acc]}
      end
    end

    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, Enum.reverse(acc), []}
    end

    data =
      File.stream!("data/day_01.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.chunk_while([], chunk_fun, after_fun)
      |> Enum.map(fn nums -> Enum.map(nums, &String.to_integer/1) end)

    IO.inspect(data)

    [part1(data), part2(data)]
  end

  def part1(data) do
    data |> Enum.map(&Enum.sum/1) |> Enum.max() |> IO.inspect()
  end

  def part2(data) do
    data
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
    |> IO.inspect()
  end
end
