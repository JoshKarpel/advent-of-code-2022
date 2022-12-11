defmodule Day11 do
  def solve do
    monkeys =
      File.stream!("data/day_11.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))
      |> Enum.chunk_every(6)
      |> IO.inspect()
      |> Enum.map(&parse_monkey/1)
      |> Map.new(fn m -> {Map.get(m, :n), m} end)

    rounds = 20
    m = monkeys |> Map.keys() |> Enum.max()

    final =
      1..rounds
      |> Enum.reduce(monkeys, fn r, round_acc ->
        0..m
        |> Enum.reduce(round_acc, fn monkey_number, turn_acc ->
          IO.puts("round #{r} monkey #{monkey_number} is about to go")
          monkey_at_turn_start = turn_acc |> Map.get(monkey_number)

          turn_acc =
            monkey_at_turn_start
            |> Map.get(:items)
            |> Enum.reverse()
            |> Enum.reduce(turn_acc, fn worry, item_acc ->
              IO.puts("  Inspect item with worry #{worry}")
              new_worry = div(Map.get(monkey_at_turn_start, :op).(worry), 3)
              IO.puts("  New worry is #{new_worry}")
              test = rem(new_worry, Map.get(monkey_at_turn_start, :div)) == 0
              target = Map.get(monkey_at_turn_start, test)
              IO.puts("  Test is #{test}, target is monkey #{target}\n")

              item_acc
              |> Map.update!(target, fn target_monkey ->
                target_monkey |> Map.update!(:items, fn items -> [new_worry | items] end)
              end)
            end)
            |> Map.update!(monkey_number, fn monkey_that_just_went ->
              monkey_that_just_went
              |> Map.update!(:items, fn _ -> [] end)
              |> Map.update!(:count, fn curr ->
                curr + (monkey_that_just_went |> Map.get(:items) |> Enum.count())
              end)
            end)

          turn_acc
          |> IO.inspect(label: "after round #{r} monkey #{monkey_number}", charlists: :as_lists)
        end)
      end)
      |> IO.inspect()

    {final
     |> Enum.map(fn {_, m} -> Map.get(m, :count) end)
     |> Enum.sort_by(& &1, :desc)
     |> Enum.take(2)
     |> Enum.product(), 0}
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
end
