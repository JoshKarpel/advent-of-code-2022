defmodule Day04 do
  def solve do
    rucksacks =
      File.stream!("data/day_04.txt")
      |> Enum.map(&String.trim(&1))

    {0, 0}
  end
end
