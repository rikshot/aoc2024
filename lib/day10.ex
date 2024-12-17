defmodule Day10 do
  @behaviour Day

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn height ->
        case Integer.parse(height) do
          {height, _} -> height
          :error -> nil
        end
      end)
    end)
  end

  defp travel(input, {x, y}, path) do
    width = input |> Enum.at(0) |> length()
    height = input |> length()
    start = input |> Enum.at(y) |> Enum.at(x)

    [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
    |> Enum.flat_map(fn {dx, dy} ->
      x = x + dx
      y = y + dy

      if x >= 0 and x < width and y >= 0 and y < height do
        value = input |> Enum.at(y) |> Enum.at(x)

        cond do
          value == start + 1 and value != 9 -> travel(input, {x, y}, [{x, y} | path])
          value == start + 1 and value == 9 -> [{x, y}]
          true -> []
        end
      else
        []
      end
    end)
  end

  def part1(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {value, x} ->
        if value == 0 do
          travel(input, {x, y}, [{x, y}])
          |> Enum.uniq()
        else
          []
        end
      end)
      |> Enum.filter(&(&1 != []))
      |> Enum.map(&Enum.count/1)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.flat_map(fn {value, x} ->
        if value == 0 do
          travel(input, {x, y}, [{x, y}])
        else
          []
        end
      end)
    end)
    |> Enum.count()
  end
end
