defmodule Day6 do
  @behaviour Day

  def parse(input) do
    input = input |> String.split("\n") |> Enum.map(&String.graphemes/1)

    {blocks, guard} =
      input
      |> Enum.with_index()
      |> Enum.reduce({MapSet.new(), nil}, fn {line, y}, {blocks, guard} ->
        line
        |> Enum.with_index()
        |> Enum.reduce({blocks, guard}, fn {char, x}, {blocks, guard} ->
          case char do
            "#" -> {blocks |> MapSet.put({x, y}), guard}
            "^" -> {blocks, {x, y}}
            _ -> {blocks, guard}
          end
        end)
      end)

    {input |> Enum.at(0) |> length(), input |> length(), blocks, guard}
  end

  defp rotate(delta) do
    case delta do
      {0, -1} -> {1, 0}
      {1, 0} -> {0, 1}
      {0, 1} -> {-1, 0}
      {-1, 0} -> {0, -1}
    end
  end

  defp walk(width, height, blocks, {x, y}, {dx, dy}, visited, loops, check_loops \\ false) do
    cond do
      x >= width or x < 0 or y >= height or y < 0 ->
        {visited, loops}

      visited |> MapSet.member?({{x, y}, {dx, dy}}) ->
        :loop

      blocks |> MapSet.member?({x + dx, y + dy}) ->
        walk(width, height, blocks, {x, y}, rotate({dx, dy}), visited, loops, check_loops)

      check_loops && not (blocks |> MapSet.member?({x + dx, y + dy})) &&
        not (visited
             |> MapSet.to_list()
             |> Enum.map(&elem(&1, 0))
             |> Enum.member?({x + dx, y + dy})) &&
          walk(
            width,
            height,
            blocks |> MapSet.put({x + dx, y + dy}),
            {x, y},
            {dx, dy},
            visited,
            loops
          ) ==
            :loop ->
        walk(
          width,
          height,
          blocks,
          {x + dx, y + dy},
          {dx, dy},
          visited |> MapSet.put({{x, y}, {dx, dy}}),
          [{x + dx, y + dy} | loops],
          check_loops
        )

      true ->
        walk(
          width,
          height,
          blocks,
          {x + dx, y + dy},
          {dx, dy},
          visited |> MapSet.put({{x, y}, {dx, dy}}),
          loops,
          check_loops
        )
    end
  end

  def part1({width, height, blocks, guard}) do
    walk(width, height, blocks, guard, {0, -1}, MapSet.new(), [])
    |> elem(0)
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2({width, height, blocks, guard}) do
    walk(width, height, blocks, guard, {0, -1}, MapSet.new(), [], true)
    |> elem(1)
    |> Enum.uniq()
    |> Enum.count()
  end
end
