defmodule Day20 do
  def solve do
    File.stream!("data/day_20.txt")
    |> Enum.map(&String.trim/1)
    |> IO.inspect()

    {0, 0}
  end
end
