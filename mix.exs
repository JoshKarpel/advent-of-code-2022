defmodule Advent.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [main_module: Advent]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8.2"},
      {:jason, "~> 1.4"},
      {:dotenv, "~> 3.1.0", only: [:dev, :test]}
    ]
  end
end
