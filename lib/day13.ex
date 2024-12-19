defmodule Day13 do
  @behaviour Day

  def parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn machine ->
      machine
      |> String.split("\n")
      |> Enum.map(fn line ->
        Regex.scan(~r/\d+/, line) |> List.flatten() |> Enum.map(&String.to_integer/1)
      end)
    end)
  end

  def part1(input) do
    input
    |> Enum.map(fn [[ax, ay], [bx, by], [x, y]] ->
      a_max = min(x |> div(ax), y |> div(ay))
      b_max = min(x |> div(bx), y |> div(by))
      pairs = for a <- 0..a_max, b <- 0..b_max, do: {a, b}

      pairs
      |> Enum.filter(fn {a, b} ->
        a * ax + b * bx == x and a * ay + b * by == y
      end)
      |> Enum.map(fn {a, b} ->
        a * 3 + b
      end)
      |> Enum.min(fn -> 0 end)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(fn [[ax, ay], [bx, by], [x, y]] ->
      x = x + 10_000_000_000_000
      y = y + 10_000_000_000_000

      {b, b_rem} =
        {(ay * x - ax * y) |> div(ay * bx - ax * by), (ay * x - ax * y) |> rem(ay * bx - ax * by)}

      {a, a_rem} = {(x - b * bx) |> div(ax), (x - b * bx) |> rem(ax)}

      if b_rem > 0 or a_rem > 0, do: 0, else: 3 * a + b
    end)
    |> Enum.sum()
  end
end
