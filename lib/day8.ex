defmodule Day8 do
  @behaviour Day

  def parse(input) do
    input = input |> String.split("\n") |> Enum.map(&String.graphemes/1)
    width = input |> Enum.at(0) |> length()
    height = input |> length()

    {width, height,
     input
     |> Enum.with_index()
     |> Enum.flat_map(fn {line, y} ->
       line
       |> Enum.with_index()
       |> Enum.filter(fn {char, _} -> char != "." end)
       |> Enum.map(fn {char, x} ->
         {char, {x, y}}
       end)
     end)
     |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))}
  end

  def part1({width, height, groups}) do
    groups
    |> Map.values()
    |> Enum.flat_map(fn coords ->
      coords
      |> Enum.flat_map(fn {a, b} ->
        coords
        |> Enum.filter(fn {c, d} -> {a, b} != {c, d} end)
        |> Enum.map(fn {c, d} ->
          {dx, dy} = {a - c, b - d}
          {a + dx, b + dy}
        end)
        |> Enum.filter(fn {x, y} -> x >= 0 and x < width and y >= 0 and y < height end)
      end)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2({width, height, groups}) do
    groups
    |> Map.values()
    |> Enum.flat_map(fn coords ->
      coords
      |> Enum.flat_map(fn {a, b} ->
        coords
        |> Enum.filter(fn {c, d} -> {a, b} != {c, d} end)
        |> Enum.flat_map(fn {c, d} ->
          {dx, dy} = {a - c, b - d}
          x_range = if dx <= 0, do: a..0//dx, else: a..(width - 1)//dx
          y_range = if dy <= 0, do: b..0//dy, else: b..(height - 1)//dy
          Enum.zip(x_range, y_range)
        end)
      end)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end
end
