defmodule Day17 do
  def solve do
    File.stream!("data/day_17.txt")
    |> Enum.map(&String.trim/1)
    |> IO.inspect()

    {0, 0}
  end
end
