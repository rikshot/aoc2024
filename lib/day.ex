defmodule Day do
  @callback parse(String.t()) :: any()
  @callback part1(any()) :: any()
  @callback part2(any()) :: any()
  @optional_callbacks parse: 1
end
