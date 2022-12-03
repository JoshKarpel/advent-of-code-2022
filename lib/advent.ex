defmodule Advent do
  def main(args \\ []) do
    args
    |> parse_args()
    |> run()
  end

  defp parse_args([subcommand, day]) do
    [subcommand, String.trim_leading(day, "0")]
  end

  defp run(["solve", day]) do
    solvers = %{
      "1" => &Day01.solve/0,
      "2" => &Day02.solve/0,
      "3" => &Day03.solve/0
    }

    {time, {p1, p2}} = :timer.tc(solvers[day])

    IO.puts("★★ Day #{day} ★★★★★")
    IO.puts("★ https://adventofcode.com/2022/day/#{day}")
    IO.puts("Part 1: #{p1}")
    IO.puts("Part 2: #{p2}")
    IO.puts("★ Elapsed time: #{time} µs")
    IO.puts("★★★★★★★★★★★★★★★")
  end

  defp run(["get-input", day]) do
    case HTTPoison.get("https://adventofcode.com/2022/day/#{day}/input", %{},
           hackney: [
             cookie: "session=#{System.get_env("AOC_SESSION")}"
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        path = "data/day_#{String.pad_leading(day, 2, ["0"])}.txt"
        File.mkdir_p!(Path.dirname(path))
        File.write!(path, body)
        IO.puts("Wrote input to #{path}")

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts("HTTP #{status_code} error while getting puzzle input. Response:\n#{body}")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
