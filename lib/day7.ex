defmodule Day7 do
  @behaviour Day

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      [result, numbers] = line |> String.split(": ")

      {result |> String.to_integer(),
       numbers |> String.split(" ") |> Enum.map(&String.to_integer/1)}
    end)
  end

  defp validate(result, numbers, concat \\ false, partial \\ nil) do
    case numbers do
      [] ->
        result == partial

      [next | numbers] ->
        if partial == nil do
          validate(result, numbers, concat, next)
        else
          validate(result, numbers, concat, partial + next) or
            validate(result, numbers, concat, partial * next) or
            (concat and
               validate(
                 result,
                 numbers,
                 concat,
                 ((partial |> Integer.to_string()) <> (next |> Integer.to_string()))
                 |> String.to_integer()
               ))
        end
    end
  end

  def part1(input) do
    input
    |> Enum.map(fn {result, numbers} ->
      if validate(result, numbers), do: result, else: 0
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(fn {result, numbers} ->
      if validate(result, numbers, true), do: result, else: 0
    end)
    |> Enum.sum()
  end
end
