defmodule Day07 do
  @total 70_000_000
  @desired_unused 30_000_000

  def solve do
    dir_sizes_by_path =
      File.stream!("data/day_07.txt")
      |> Enum.map(&String.trim_trailing/1)
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

  def execute(instructions) do
    {_, dir_sizes} =
      instructions
      |> Enum.reduce({[], %{}}, fn instruction, {path, dir_sizes} ->
        case instruction |> String.split() do
          ["$", "cd", ".."] ->
            {List.delete_at(path, 0), dir_sizes}

          ["$", "cd", target] ->
            {
              [target | path],
              dir_sizes
            }

          ["$", "ls"] ->
            {path, dir_sizes}

          ["dir", _name] ->
            {path, dir_sizes}

          [size, _name] ->
            path
            |> Enum.reverse()
            |> Enum.reduce({[], dir_sizes}, fn p, {path, ds} ->
              new_path = [p | path]
              s = String.to_integer(size)

              {new_path, Map.update(ds, new_path, s, &(&1 + s))}
            end)

          _ ->
            {path, dir_sizes}
        end
      end)

    dir_sizes
  end
end
