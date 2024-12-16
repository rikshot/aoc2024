defmodule Day9 do
  @behaviour Day

  def parse(input) do
    input |> String.graphemes() |> Enum.map(&String.to_integer/1) |> Arrays.new()
  end

  defp expand(input) do
    input
    |> Arrays.reduce({Arrays.new(), 0, true}, fn length, {expanded, id, file} ->
      {expanded
       |> Arrays.concat(Arrays.empty(size: length, default: if(file, do: id, else: nil))),
       if(file, do: id + 1, else: id), not file}
    end)
    |> elem(0)
  end

  defp pack(array, start_index, end_index) do
    value = array |> Arrays.get(start_index)
    last_value = array |> Arrays.get(end_index)

    cond do
      value != nil ->
        pack(array, start_index + 1, end_index)

      last_value == nil ->
        pack(array, start_index, end_index - 1)

      start_index >= end_index ->
        array

      true ->
        pack(
          array |> Arrays.replace(start_index, last_value) |> Arrays.replace(end_index, nil),
          start_index + 1,
          end_index - 1
        )
    end
  end

  def part1(input) do
    expanded = input |> expand()

    expanded
    |> pack(0, Arrays.size(expanded) - 1)
    |> Enum.filter(fn value -> value != nil end)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      value * index
    end)
    |> Enum.sum()
  end

  defp pack_blocks(array, block_end) do
    {block_start, block_end} =
      block_end..0
      |> Enum.reduce_while({nil, nil, nil}, fn index, {block_start, block_end, file} ->
        value = array |> Arrays.get(index)

        cond do
          index == 0 ->
            {:halt, {0, block_end}}

          value != nil && block_end == nil ->
            {:cont, {nil, index, value}}

          block_end != nil and block_start == nil and (value == nil or value != file) ->
            {:halt, {index + 1, block_end}}

          true ->
            {:cont, {block_start, block_end, file}}
        end
      end)

    block_size = block_end - block_start + 1

    {free_start, free_end} =
      0..block_start
      |> Enum.reduce_while({nil, nil}, fn index, {free_start, free_end} ->
        value = array |> Arrays.get(index)

        cond do
          value == nil && free_start == nil ->
            {:cont, {index, nil}}

          free_start != nil and free_end == nil and value != nil ->
            free_size = index - 1 - free_start + 1

            if free_size >= block_size do
              {:halt, {free_start, index - 1}}
            else
              {:cont, {nil, nil}}
            end

          true ->
            {:cont, {free_start, free_end}}
        end
      end)

    cond do
      block_start == 0 ->
        array

      free_start == nil and free_end == nil ->
        pack_blocks(array, block_start - 1)

      true ->
        array =
          block_start..block_end
          |> Enum.zip(free_start..free_end)
          |> Enum.reduce(array, fn {block_index, free_index}, array ->
            array
            |> Arrays.replace(free_index, array |> Arrays.get(block_index))
            |> Arrays.replace(block_index, nil)
          end)

        pack_blocks(array, block_start - 1)
    end
  end

  # TODO: Make faster by calculating free spaces only once
  def part2(input) do
    expanded = input |> expand()

    expanded
    |> pack_blocks(Arrays.size(expanded) - 1)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      if value == nil, do: 0, else: value * index
    end)
    |> Enum.sum()
  end
end
