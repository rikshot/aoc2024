defmodule Day15 do
  @behaviour Day

  def parse(input) do
    [grid, moves] = input |> String.split("\n\n")

    {grid
     |> String.split("\n")
     |> Enum.with_index()
     |> Enum.reduce({MapSet.new(), MapSet.new(), nil}, fn {line, y}, {walls, boxes, robot} ->
       line
       |> String.graphemes()
       |> Enum.with_index()
       |> Enum.reduce({walls, boxes, robot}, fn {char, x}, state = {walls, boxes, robot} ->
         case char do
           "#" ->
             {walls |> MapSet.put({x, y}), boxes, robot}

           "O" ->
             {walls, boxes |> MapSet.put({x, y}), robot}

           "@" ->
             {walls, boxes, {x, y}}

           _ ->
             state
         end
       end)
     end),
     moves
     |> String.graphemes()
     |> Enum.filter(&(&1 != "\n"))
     |> Enum.map(fn char ->
       case char do
         "^" ->
           {0, -1}

         ">" ->
           {1, 0}

         "v" ->
           {0, 1}

         "<" ->
           {-1, 0}
       end
     end)}
  end

  defp push(walls, boxes, {x, y}, {dx, dy}) do
    nx = x + dx
    ny = y + dy

    cond do
      walls |> MapSet.member?({nx, ny}) ->
        false

      boxes |> MapSet.member?({nx, ny}) ->
        case push(walls, boxes, {nx, ny}, {dx, dy}) do
          false -> false
          boxes -> boxes |> MapSet.delete({x, y}) |> MapSet.put({nx, ny})
        end

      true ->
        boxes |> MapSet.delete({x, y}) |> MapSet.put({nx, ny})
    end
  end

  defp draw_state(width, height, {walls, boxes, robot}) do
    0..height
    |> Enum.each(fn y ->
      0..width
      |> Enum.each(fn x ->
        cond do
          walls |> MapSet.member?({x, y}) -> IO.write("#")
          boxes |> MapSet.member?({x, y}) -> IO.write("O")
          {x, y} == robot -> IO.write("@")
          true -> IO.write(".")
        end
      end)

      IO.write("\n")
    end)

    IO.write("\n")
  end

  def part1({grid, moves}) do
    {_, boxes, _} =
      moves
      |> Enum.reduce(grid, fn {dx, dy}, _state = {walls, boxes, robot = {x, y}} ->
        nx = x + dx
        ny = y + dy

        cond do
          walls |> Enum.member?({nx, ny}) ->
            {walls, boxes, robot}

          boxes |> Enum.member?({nx, ny}) ->
            case push(walls, boxes, {nx, ny}, {dx, dy}) do
              false -> {walls, boxes, robot}
              boxes -> {walls, boxes, {nx, ny}}
            end

          true ->
            {walls, boxes, {nx, ny}}
        end
      end)

    boxes
    |> Enum.map(fn {x, y} ->
      100 * y + x
    end)
    |> Enum.sum()
  end

  def part2(_input) do
  end
end
