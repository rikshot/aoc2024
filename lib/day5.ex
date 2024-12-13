defmodule Day5 do
  @behaviour Day

  def parse(input) do
    [rules, updates] = input |> String.split("\n\n")

    {rules
     |> String.split("\n")
     |> Enum.map(fn rule ->
       rule |> String.split("|") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
     end),
     updates
     |> String.split("\n")
     |> Enum.map(fn update ->
       update |> String.split(",") |> Enum.map(&String.to_integer/1)
     end)}
  end

  defp filter_rules(rules, update) do
    rules
    |> Enum.filter(fn {a, b} ->
      update |> Enum.member?(a) && update |> Enum.member?(b)
    end)
  end

  defp is_correct(rules, update) do
    filter_rules(rules, update)
    |> Enum.all?(fn {a, b} ->
      a_index = update |> Enum.find_index(&(&1 == a))
      b_index = update |> Enum.find_index(&(&1 == b))
      a_index < b_index and b_index > a_index
    end)
  end

  defp get_middle(update) do
    update |> Enum.at((length(update) - 1) |> div(2))
  end

  def part1({rules, updates}) do
    updates
    |> Enum.filter(&is_correct(rules, &1))
    |> Enum.map(&get_middle/1)
    |> Enum.sum()
  end

  defp apply_rules(rules, update) do
    update =
      filter_rules(rules, update)
      |> Enum.reduce(update, fn {a, b}, update ->
        a_index = update |> Enum.find_index(&(&1 == a))
        b_index = update |> Enum.find_index(&(&1 == b))

        if a_index > b_index or b_index < a_index do
          update |> List.replace_at(a_index, b) |> List.replace_at(b_index, a)
        else
          update
        end
      end)

    if is_correct(rules, update) do
      update
    else
      apply_rules(rules, update)
    end
  end

  def part2({rules, updates}) do
    updates
    |> Enum.filter(&(not is_correct(rules, &1)))
    |> Enum.map(&apply_rules(rules, &1))
    |> Enum.map(&get_middle/1)
    |> Enum.sum()
  end
end
