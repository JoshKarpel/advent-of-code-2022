defmodule Day03 do
  def solve do
    rounds =
      File.stream!("data/day_02.txt")
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(&List.to_tuple(&1))

    {0, 0}
  end
end
