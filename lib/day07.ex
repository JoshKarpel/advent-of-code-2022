defmodule Day07 do
  @total 70_000_000
  @desired_unused 30_000_000

  def solve do
    dir_sizes_by_path =
      File.stream!("data/day_07.txt")
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.map(&parse_line/1)
      |> execute

    used = dir_sizes_by_path |> Map.get(["/"])
    min_to_delete = @desired_unused - (@total - used)

    dir_sizes =
      dir_sizes_by_path
      |> Map.values()

    {dir_sizes
     |> Enum.filter(&(&1 <= 100_000))
     |> Enum.sum(),
     dir_sizes
     |> Enum.filter(&(&1 >= min_to_delete))
     |> Enum.min()}
  end

  def parse_line(line) do
    case line |> String.split() do
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
    {_, dir_sizes} =
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

          {:file, _name, size} ->
            path
            |> Enum.reverse()
            |> Enum.reduce({[], dir_sizes}, fn p, {path, ds} ->
              {[p | path],
               Map.update(ds, [p | path], size, fn existing_value -> existing_value + size end)}
            end)

          _ ->
            {path, dir_sizes}
        end
      end)

    dir_sizes
  end
end
