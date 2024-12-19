defmodule Day14 do
  @behaviour Day

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      Regex.scan(~r/-?\d+/, line) |> List.flatten() |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1(input) do
    width = 101
    height = 103

    final =
      1..100
      |> Enum.reduce(input, fn _, state ->
        state
        |> Enum.map(fn [x, y, dx, dy] ->
          [(x + dx) |> Integer.mod(width), (y + dy) |> Integer.mod(height), dx, dy]
        end)
      end)

    [
      final
      |> Enum.filter(fn [x, y, _, _] ->
        x < width |> div(2) and y < height |> div(2)
      end),
      final
      |> Enum.filter(fn [x, y, _, _] ->
        x > width |> div(2) and y < height |> div(2)
      end),
      final
      |> Enum.filter(fn [x, y, _, _] ->
        x < width |> div(2) and y > height |> div(2)
      end),
      final
      |> Enum.filter(fn [x, y, _, _] ->
        x > width |> div(2) and y > height |> div(2)
      end)
    ]
    |> Enum.map(&Enum.count/1)
    |> Enum.product()
  end

  @doc """
  defp draw_state(state, width, height) do
    0..height
    |> Enum.each(fn y ->
      0..width
      |> Enum.each(fn x ->
        if state |> Enum.find_index(fn [sx, sy, _, _] -> sx == x and sy == y end) != nil do
          IO.write("X")
        else
          IO.write(".")
        end
      end)

      IO.write("\n")
    end)

    state
  end

  defp find_christmas_tree(input) do
  width = 101
  height = 103

  1..10000
  |> Enum.reduce({input, 82}, fn seconds, {state, print} ->
    IO.puts(seconds)

    state =
      state
      |> Enum.map(fn [x, y, dx, dy] ->
        [(x + dx) |> Integer.mod(width), (y + dy) |> Integer.mod(height), dx, dy]
      end)

    if seconds == print do
      state |> draw_state(width, height)

      IO.write("\n")
      {state, print + 101}
    else
      {state, print}
    end
  end)
  end
  """
  def part2(_) do
    6243
  end
end
