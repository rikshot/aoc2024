defmodule Mix.Tasks.Solve do
  @shortdoc "Solves the puzzles"
  @moduledoc """
  `mix solve` - solves all the defined puzzles with real inputs

  `mix solve --example` - solves all the defined puzzles with example inputs

  `mix solve --bench` - benchmarks all the defined puzzles with real inputs

  `mix solve <day>` - solves the day with real inputs

  `mix solve <day> --example` - solves the day with example inputs

  `mix solve <day> --bench` - benchmarks the day with real inputs
  """

  use Mix.Task

  defp run_day(day, example \\ false, bench \\ false) do
    case :code.ensure_loaded(String.to_atom("Elixir.Day#{day}")) do
      {:module, module} ->
        if not bench, do: IO.puts("Day #{day}:")

        filename =
          if example do
            "day#{day}.example.txt"
          else
            "day#{day}.txt"
          end

        {:ok, input} = File.read("input/#{filename}")

        input =
          if function_exported?(module, :parse, 1) do
            apply(module, :parse, [input])
          else
            input
          end

        [:part1, :part2]
        |> Enum.each(fn part ->
          if bench do
            Benchee.run(%{"Day#{day} #{part}" => fn -> apply(module, part, [input]) end},
              print: [benchmarking: false, configuration: false]
            )
          else
            result =
              apply(module, part, [input])
              |> inspect(pretty: true, charlists: :as_lists)

            IO.puts("#{result}")
          end
        end)

      _ ->
        nil
    end
  end

  @impl Mix.Task
  def run(["--example"]) do
    1..24 |> Enum.map(&run_day(&1, true))
  end

  @impl Mix.Task
  def run(["--bench"]) do
    1..24 |> Enum.map(&run_day(&1, false, true))
  end

  @impl Mix.Task
  def run([day]) do
    run_day(day)
  end

  @impl Mix.Task
  def run([day, "--example"]) do
    run_day(day, true)
  end

  @impl Mix.Task
  def run([day, "--bench"]) do
    run_day(day, false, true)
  end

  @impl Mix.Task
  def run(_) do
    1..24 |> Enum.map(&run_day/1)
  end
end
