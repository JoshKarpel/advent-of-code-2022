defmodule Day11 do
  def solve do
    monkeys =
      File.stream!("data/day_11.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))
      |> Enum.chunk_every(6)
      |> Enum.map(&parse_monkey/1)
      |> Map.new(fn m -> {Map.get(m, :n), m} end)

    {monkeys |> play(20, 3) |> business, monkeys |> play(10000, 1) |> business}
  end

  def business(monkeys) do
    monkeys
    |> Map.values()
    |> Enum.map(&Map.get(&1, :count))
    |> Enum.sort_by(& &1, :desc)
    |> Enum.take(2)
    |> Enum.product()
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
        |> Enum.map(&String.to_integer/1)
        |> Enum.reverse(),
      op:
        case Regex.run(~r/Operation: new = old (\+|\*) (.+)/, raw_operation,
               capture: :all_but_first
             ) do
          ["+", "old"] -> fn old -> old + old end
          ["*", "old"] -> fn old -> old * old end
          ["+", v] -> fn old -> old + String.to_integer(v) end
          ["*", v] -> fn old -> old * String.to_integer(v) end
        end,
      div:
        raw_test
        |> then(&Regex.run(~r/Test: divisible by (\d+)/, &1, capture: :all_but_first))
        |> Enum.at(0)
        |> String.to_integer(),
      true:
        raw_true
        |> then(&Regex.run(~r/If true: throw to monkey (\d+)/, &1, capture: :all_but_first))
        |> Enum.at(0)
        |> String.to_integer(),
      false:
        raw_false
        |> then(&Regex.run(~r/If false: throw to monkey (\d+)/, &1, capture: :all_but_first))
        |> Enum.at(0)
        |> String.to_integer(),
      count: 0
    }
  end

  def play(monkeys, rounds, reduce_by_factor) do
    num_monkeys = monkeys |> Map.keys() |> Enum.max()

    mod = monkeys |> Map.values() |> Enum.map(&Map.get(&1, :div)) |> Enum.product()

    1..rounds
    |> Enum.reduce(monkeys, fn _round_idx, round_acc ->
      0..num_monkeys
      |> Enum.reduce(round_acc, fn monkey_number, turn_acc ->
        monkey_at_turn_start = turn_acc |> Map.get(monkey_number)

        monkey_at_turn_start
        |> Map.get(:items)
        # items are held in reverse order to make throwing logic easier below
        |> Enum.reverse()
        |> Enum.reduce(turn_acc, fn worry, item_acc ->
          new_worry = rem(div(Map.get(monkey_at_turn_start, :op).(worry), reduce_by_factor), mod)

          test = rem(new_worry, Map.get(monkey_at_turn_start, :div)) == 0
          target = Map.get(monkey_at_turn_start, test)

          item_acc
          |> Map.update!(target, fn target_monkey ->
            target_monkey |> Map.update!(:items, fn items -> [new_worry | items] end)
          end)
        end)
        # now we clear out the monkey's items (it just threw all of them) and increment its inspection count
        |> Map.update!(monkey_number, fn monkey_that_just_went ->
          monkey_that_just_went
          |> Map.update!(:items, fn _ -> [] end)
          |> Map.update!(:count, fn curr ->
            curr + (monkey_that_just_went |> Map.get(:items) |> Enum.count())
          end)
        end)
      end)
    end)
  end
end
