defmodule Day07 do
  @total 70_000_000

  def solve do
    dir_sizes =
      File.stream!("data/day_07.txt")
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.map(&String.split/1)
      |> Enum.map(&parse_line/1)
      |> execute
      |> IO.inspect()

    {dir_sizes
     |> Map.values()
     |> Enum.filter(&(&1 <= 100_000))
     |> Enum.sum(), 0}
  end

  def parse_line(line) do
    case line do
      ["$", "cd", ".."] ->
        {:cd, :up}

      ["$", "cd", target] ->
        {:cd, target}

      ["$", "ls"] ->
        {:ls}

      ["dir", name] ->
        {:dir, name}

      [size, name] ->
        {:file, name, String.to_integer(size)}
    end
  end

  def execute(instructions) do
    {cwd, dir_sizes} =
      instructions
      |> Enum.reduce({[], %{}}, fn instruction, {path, dir_sizes} ->
        case instruction do
          {:cd, :up} ->
            {List.delete_at(path, 0), dir_sizes}

          {:cd, target} ->
            {
              [target | path],
              dir_sizes
            }

          {:ls} ->
            {path, dir_sizes}

          {:dir, name} ->
            {path, dir_sizes}

          {:file, name, size} ->
            path
            |> Enum.reverse()
            |> Enum.reduce({[], dir_sizes}, fn p, {path, ds} ->
              {[p | path],
               Map.update(ds, [p | path], size, fn existing_value -> existing_value + size end)}
            end)
        end
      end)

    dir_sizes
  end
end
