defmodule Day12 do
  @behaviour Day

  def parse(input) do
    input |> String.split("\n") |> Enum.map(&String.graphemes/1)
  end

  defp find_plot(input, {x, y}, value, plot) do
    width = input |> Enum.at(0) |> length()
    height = input |> length()

    [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
    |> Enum.reduce(plot, fn {dx, dy}, plot ->
      x = x + dx
      y = y + dy

      if x >= 0 and x < width and y >= 0 and y < height do
        neighbor = input |> Enum.at(y) |> Enum.at(x)

        if neighbor == value and not (plot |> MapSet.member?({x, y})) do
          plot |> MapSet.union(find_plot(input, {x, y}, value, plot |> MapSet.put({x, y})))
        else
          plot
        end
      else
        plot
      end
    end)
  end

  defp find_perimeter(plot) do
    plot
    |> Enum.map(fn {x, y} ->
      [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
      |> Enum.reduce(4, fn {dx, dy}, count ->
        if plot |> MapSet.member?({x + dx, y + dy}) do
          count - 1
        else
          count
        end
      end)
    end)
    |> Enum.sum()
  end

  def part1(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce({MapSet.new(), []}, fn {line, y}, {visited, plots} ->
      line
      |> Enum.with_index()
      |> Enum.reduce({visited, plots}, fn {char, x}, {visited, plots} ->
        if visited |> MapSet.member?({x, y}) do
          {visited, plots}
        else
          plot = find_plot(input, {x, y}, char, MapSet.new([{x, y}]))
          {visited |> MapSet.union(plot), [plot | plots]}
        end
      end)
    end)
    |> elem(1)
    |> Enum.map(fn plot ->
      (plot |> Enum.count()) * (plot |> find_perimeter())
    end)
    |> Enum.sum()
  end

  defp find_sides(plot) do
    {min_x, max_x} =
      plot |> Enum.map(&elem(&1, 0)) |> Enum.uniq() |> Enum.min_max()

    {min_y, max_y} =
      plot |> Enum.map(&elem(&1, 1)) |> Enum.uniq() |> Enum.min_max()

    [
      min_y..max_y
      |> Enum.reduce([], fn y, sides ->
        (min_x - 1)..(max_x + 1)
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce(sides, fn [left, right], sides ->
          cond do
            plot |> MapSet.member?({left, y}) and not (plot |> MapSet.member?({right, y})) ->
              [{left + 0.5, y, :left} | sides]

            plot |> MapSet.member?({right, y}) and not (plot |> MapSet.member?({left, y})) ->
              [{right - 0.5, y, :right} | sides]

            true ->
              sides
          end
        end)
      end)
      |> Enum.group_by(fn {x, _, dir} -> {x, dir} end, fn {_, y, dir} -> {y, dir} end)
      |> Map.values()
      |> Enum.map(fn values ->
        values
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce(1, fn pair, count ->
          case pair do
            [_] -> count
            [{a, _}, {b, _}] -> if b == a - 1, do: count, else: count + 1
          end
        end)
      end),
      min_x..max_x
      |> Enum.reduce([], fn x, sides ->
        (min_y - 1)..(max_y + 1)
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce(sides, fn [up, down], sides ->
          cond do
            plot |> MapSet.member?({x, up}) and not (plot |> MapSet.member?({x, down})) ->
              [{x, up + 0.5, :up} | sides]

            plot |> MapSet.member?({x, down}) and not (plot |> MapSet.member?({x, up})) ->
              [{x, down - 0.5, :down} | sides]

            true ->
              sides
          end
        end)
      end)
      |> Enum.group_by(fn {_, y, dir} -> {y, dir} end, fn {x, _, dir} -> {x, dir} end)
      |> Map.values()
      |> Enum.map(fn values ->
        values
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce(1, fn pair, count ->
          case pair do
            [_] -> count
            [{a, _}, {b, _}] -> if b == a - 1, do: count, else: count + 1
          end
        end)
      end)
    ]
    |> List.flatten()
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce({MapSet.new(), []}, fn {line, y}, {visited, plots} ->
      line
      |> Enum.with_index()
      |> Enum.reduce({visited, plots}, fn {char, x}, {visited, plots} ->
        if visited |> MapSet.member?({x, y}) do
          {visited, plots}
        else
          plot = find_plot(input, {x, y}, char, MapSet.new([{x, y}]))
          {visited |> MapSet.union(plot), [plot | plots]}
        end
      end)
    end)
    |> elem(1)
    |> Enum.map(fn plot ->
      (plot |> Enum.count()) * (plot |> find_sides())
    end)
    |> Enum.sum()
  end
end
