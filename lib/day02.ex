defmodule Day02 do
  def solve do
    rounds =
      File.stream!("data/day_02.txt")
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(&List.to_tuple(&1))

    [
      rounds
      |> Enum.map(&play/1)
      |> Enum.sum(),
      rounds
      |> Enum.map(&pick/1)
      |> Enum.sum()
    ]
  end

  @win 6
  @draw 3
  @loss 0

  @rock 1
  @paper 2
  @scissors 3

  def play(round) do
    case round do
      {"A", "X"} -> @rock + @draw
      {"B", "X"} -> @rock + @loss
      {"C", "X"} -> @rock + @win
      {"A", "Y"} -> @paper + @win
      {"B", "Y"} -> @paper + @draw
      {"C", "Y"} -> @paper + @loss
      {"A", "Z"} -> @scissors + @loss
      {"B", "Z"} -> @scissors + @win
      {"C", "Z"} -> @scissors + @draw
    end
  end

  def pick(round) do
    case round do
      {"A", "X"} -> @scissors + @loss
      {"B", "X"} -> @rock + @loss
      {"C", "X"} -> @paper + @loss
      {"A", "Y"} -> @rock + @draw
      {"B", "Y"} -> @paper + @draw
      {"C", "Y"} -> @scissors + @draw
      {"A", "Z"} -> @paper + @win
      {"B", "Z"} -> @scissors + @win
      {"C", "Z"} -> @rock + @win
    end
  end
end
