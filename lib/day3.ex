defmodule Day3 do
  @behaviour Day

  defp parser(), do: ~r/mul\((\d{1,3}),(\d{1,3})\)/
  defp conditional_parser(), do: ~r/(do)\(\)|(don\'t)\(\)|mul\((\d{1,3}),(\d{1,3})\)/

  def part1(input) do
    Regex.scan(parser(), input)
    |> Enum.map(fn [_, a, b] ->
      String.to_integer(a) * String.to_integer(b)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    Regex.scan(conditional_parser(), input)
    |> Enum.reduce({true, 0}, fn command, {enabled, acc} ->
      case command do
        ["do()" | _] ->
          {true, acc}

        ["don't()" | _] ->
          {false, acc}

        [_, _, _, a, b] ->
          if enabled do
            {enabled, acc + String.to_integer(a) * String.to_integer(b)}
          else
            {enabled, acc}
          end
      end
    end)
    |> elem(1)
  end
end
