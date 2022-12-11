defmodule Day11 do
  def solve do
    File.stream!("data/day_11.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.chunk_every(6)
    |> IO.inspect()
    |> Enum.map(&parse_monkey/1)
    |> Map.new(fn m -> {Map.get(m, :n), m} end)
    |> IO.inspect(charlists: :as_lists)

    {0, 0}
  end

  def parse_monkey([raw_num, raw_starting_items, raw_operation, raw_test, raw_true, raw_false]) do
    %{
      n:
        raw_num
        |> then(&Regex.run(~r/Monkey (\d)/, &1, capture: :all_but_first))
        |> Enum.at(0)
        |> String.to_integer(),
      items:
        raw_starting_items
        |> then(&Regex.run(~r/Starting items: ([\d\s,]+)/, &1, capture: :all_but_first))
        |> Enum.at(0)
        |> String.split(", ")
        |> Enum.map(&String.to_integer/1),
      op:
        case Regex.run(~r/Operation: new = old (\+|\*) (.+)/, raw_operation,
               capture: :all_but_first
             ) do
          ["+", "old"] -> fn old -> old + old end
          ["*", "old"] -> fn old -> old * old end
          ["+", v] -> fn old -> old + String.to_integer(v) end
          ["*", v] -> fn old -> old * String.to_integer(v) end
        end,
      divisor:
        raw_test
        |> then(&Regex.run(~r/Test: divisible by (\d+)/, &1, capture: :all_but_first))
        |> Enum.at(0)
        |> String.to_integer(),
      t:
        raw_true
        |> then(&Regex.run(~r/If true: throw to monkey (\d+)/, &1, capture: :all_but_first))
        |> Enum.at(0)
        |> String.to_integer(),
      f:
        raw_false
        |> then(&Regex.run(~r/If false: throw to monkey (\d+)/, &1, capture: :all_but_first))
        |> Enum.at(0)
        |> String.to_integer()
    }
  end
end
