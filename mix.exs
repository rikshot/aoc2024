defmodule AoC.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.17",
      deps: deps()
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: [:dev, :test]}
    ]
  end
end
