defmodule Day4 do
  @behaviour Day

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.graphemes()
    end)
  end

  defp deltas(), do: [{1, 0}, {-1, 0}, {0, -1}, {0, 1}, {-1, -1}, {1, -1}, {-1, 1}, {1, 1}]

  defp get_char(grid, {x, y}) do
    grid |> Enum.at(y) |> Enum.at(x)
  end

  defp find_word(grid, {x, y}, {dx, dy}, word) do
    width = grid |> Enum.at(0) |> length()
    height = grid |> length()

    word
    |> String.graphemes()
    |> Enum.reduce_while({x, y}, fn char, {x, y} ->
      if x >= 0 and x < width and y >= 0 and y < height and
           get_char(grid, {x, y}) == char do
        {:cont, {x + dx, y + dy}}
      else
        {:halt, false}
      end
    end)
  end

  def part1(input) do
    width = input |> Enum.at(0) |> length()
    height = input |> length()

    0..(width - 1)
    |> Enum.reduce(0, fn x, count ->
      0..(height - 1)
      |> Enum.reduce(count, fn y, count ->
        deltas()
        |> Enum.reduce(count, fn delta, count ->
          if find_word(input, {x, y}, delta, "XMAS"), do: count + 1, else: count
        end)
      end)
    end)
  end

  defp patterns(),
    do: [
      [["M", nil, "M"], [nil, "A", nil], ["S", nil, "S"]],
      [["S", nil, "M"], [nil, "A", nil], ["S", nil, "M"]],
      [["S", nil, "S"], [nil, "A", nil], ["M", nil, "M"]],
      [["M", nil, "S"], [nil, "A", nil], ["M", nil, "S"]]
    ]

  def part2(input) do
    width = input |> Enum.at(0) |> length()
    height = input |> length()

    0..(width - 3)
    |> Enum.reduce(0, fn x, count ->
      0..(height - 3)
      |> Enum.reduce(count, fn y, count ->
        if patterns()
           |> Enum.any?(fn pattern ->
             0..2
             |> Enum.all?(fn dx ->
               0..2
               |> Enum.all?(fn dy ->
                 test = get_char(pattern, {dx, dy})
                 test == nil or test == get_char(input, {x + dx, y + dy})
               end)
             end)
           end),
           do: count + 1,
           else: count
      end)
    end)
  end
end
