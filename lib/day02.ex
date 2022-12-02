defmodule Day02 do
  def solve do
    pairs =
      File.stream!("data/day_02.txt")
      |> Enum.map(&String.split(String.trim(&1), " "))

    [
      pairs
      |> Enum.map(&score/1)
      |> Enum.sum(),
      pairs
      |> Enum.map(&pick/1)
      |> Enum.sum()
    ]
  end

  def pick([them, me]) do
    case [them, me] do
      ["A", "X"] -> 3 + 0
      ["B", "X"] -> 1 + 0
      ["C", "X"] -> 2 + 0
      ["A", "Y"] -> 1 + 3
      ["B", "Y"] -> 2 + 3
      ["C", "Y"] -> 3 + 3
      ["A", "Z"] -> 2 + 6
      ["B", "Z"] -> 3 + 6
      ["C", "Z"] -> 1 + 6
    end
  end

  def rps([them, me]) do
    case [them, me] do
      ["A", "X"] -> :tie
      ["B", "X"] -> :loss
      ["C", "X"] -> :win
      ["A", "Y"] -> :win
      ["B", "Y"] -> :tie
      ["C", "Y"] -> :loss
      ["A", "Z"] -> :loss
      ["B", "Z"] -> :win
      ["C", "Z"] -> :tie
    end
  end

  def score([them, me]) do
    mine =
      case me do
        "X" -> 1
        "Y" -> 2
        "Z" -> 3
      end

    outcome =
      case rps([them, me]) do
        :win -> 6
        :tie -> 3
        :loss -> 0
      end

    mine + outcome
  end
end
