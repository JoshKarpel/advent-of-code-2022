defmodule Advent do
  def main(args \\ []) do
    args
    |> parse_args()
    |> solve()
  end

  defp parse_args(args) do
    String.pad_leading(List.first(args), 2, ["0"])
  end

  defp solve(day) do
    solvers = %{
      "01" => &Day01.solve/0
    }

    {time, [p1, p2]} = :timer.tc(solvers[day])

    IO.puts(["★★ Day ", day, " ★★★★★"])
    IO.puts(["★ https://adventofcode.com/2022/day/", String.trim_leading(day, "0")])
    IO.puts(["Part 1: ", to_string(p1)])
    IO.puts(["Part 2: ", to_string(p2)])
    IO.puts(["★ Elapsed time: ", to_string(time), " µs"])
    IO.puts("★★★★★★★★★★★★★★★")
  end
end
