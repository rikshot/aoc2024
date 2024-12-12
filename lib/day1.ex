defmodule Day1 do
  @behaviour Day

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.split("   ") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
    |> Enum.unzip()
  end

  def part1({a, b}) do
    Enum.zip(a |> Enum.sort(), b |> Enum.sort())
    |> Enum.map(fn {a, b} ->
      abs(a - b)
    end)
    |> Enum.sum()
  end

  def part2({a, b}) do
    a
    |> Enum.map(fn a ->
      a * Enum.count(b, &(a == &1))
    end)
    |> Enum.sum()
  end
end
