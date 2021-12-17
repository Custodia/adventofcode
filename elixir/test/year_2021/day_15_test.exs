defmodule AdventOfCode.Year2021.Day15Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2021

  test "part1" do
    assert Year2021.Day15.part1 == 441
  end

  @tag :slow
  test "part2" do
    assert Year2021.Day15.part2 == 2849
  end
end
