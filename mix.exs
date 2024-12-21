defmodule AoC.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.18",
      deps: deps()
    ]
  end

  defp deps do
    [
      {:arrays, "~> 2.1"},
      {:benchee, "~> 1.0", only: [:dev, :test]}
    ]
  end
end
