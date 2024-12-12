defmodule Day2 do
  @behaviour Day

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.split(" ") |> Enum.map(&String.to_integer/1)
    end)
  end

  defp is_safe(report) do
    pairs =
      report
      |> Enum.chunk_every(2, 1, :discard)

    (pairs |> Enum.all?(fn [a, b] -> a > b end) or pairs |> Enum.all?(fn [a, b] -> a < b end)) and
      pairs
      |> Enum.map(fn [a, b] ->
        diff = abs(a - b)
        diff >= 1 and diff <= 3
      end)
      |> Enum.all?()
  end

  def part1(input) do
    input
    |> Enum.map(&is_safe/1)
    |> Enum.count(& &1)
  end

  def part2(input) do
    input
    |> Enum.map(fn report ->
      report |> is_safe() or
        0..length(report)
        |> Enum.map(fn index ->
          report
          |> List.delete_at(index)
          |> is_safe()
        end)
        |> Enum.any?()
    end)
    |> Enum.count(& &1)
  end
end
