defmodule Day20 do
  def solve do
    numbers =
      File.stream!("data/day_20.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)
      |> IO.inspect()

    len =
      numbers
      |> Enum.count()
      |> IO.inspect(label: "total")

    {0, 0}
  end
end
