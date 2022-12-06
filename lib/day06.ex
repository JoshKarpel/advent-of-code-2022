defmodule Day06 do
  def solve do
    characters =
      File.stream!("data/day_06.txt")
      |> Enum.map(&String.trim_trailing(&1))
      |> Enum.at(0)
      |> to_charlist()

    {characters |> distinct_characters(4), characters |> distinct_characters(14)}
  end

  def distinct_characters(characters, n) do
    characters
    |> Enum.chunk_every(n, 1, :discard)
    |> Enum.find_index(&(&1 |> MapSet.new() |> MapSet.size() == n))
    |> Kernel.+(n)
  end
end
