defmodule Day11 do
  @behaviour Day

  def parse(input) do
    input |> String.split(" ") |> Enum.map(&String.to_integer/1)
  end

  defp blink(input) do
    input
    |> Enum.map(fn stone ->
      if stone == 0 do
        1
      else
        string = stone |> Integer.to_string()
        length = string |> String.length()

        if Integer.mod(length, 2) == 0 do
          string
          |> String.split_at(Integer.floor_div(length, 2))
          |> Tuple.to_list()
          |> Enum.map(&String.to_integer/1)
        else
          stone * 2024
        end
      end
    end)
    |> List.flatten()
  end

  def part1(input) do
    1..25
    |> Enum.reduce(input, fn _, input ->
      blink(input)
    end)
    |> Enum.count()
  end

  defp blink_cache(stone, depth, cache) do
    cond do
      stone == nil ->
        0

      depth == 0 ->
        1

      :ets.member(cache, {stone, depth}) ->
        :ets.lookup_element(cache, {stone, depth}, 2)

      true ->
        string = stone |> Integer.to_string()
        length = string |> String.length()

        {left, right} =
          cond do
            stone == 0 ->
              {1, nil}

            Integer.mod(length, 2) == 0 ->
              {left, right} = string |> String.split_at(Integer.floor_div(length, 2))
              {left |> String.to_integer(), right |> String.to_integer()}

            true ->
              {stone * 2024, nil}
          end

        :ets.insert(
          cache,
          {{stone, depth},
           blink_cache(left, depth - 1, cache) + blink_cache(right, depth - 1, cache)}
        )

        :ets.lookup_element(cache, {stone, depth}, 2)
    end
  end

  def part2(input) do
    cache = :ets.new(:cache, [])

    input
    |> Enum.map(fn stone ->
      blink_cache(stone, 75, cache)
    end)
    |> Enum.sum()
  end
end
