defmodule Day01 do
  def solve do
    File.stream!("data/day_01.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.flat_map(fn
      [""] -> []
      cals -> [cals |> Enum.map(&String.to_integer/1) |> Enum.sum()]
    end)
    |> Enum.sort_by(& &1, :desc)
    |> then(&[&1 |> Enum.at(0), &1 |> Enum.take(3) |> Enum.sum()])
  end
end
