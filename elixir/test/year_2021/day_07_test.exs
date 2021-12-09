defmodule AdventOfCode.Year2021.Day07Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2021

  test "part1" do
    assert Year2021.Day07.part1 == 344138
  end

  test "part2" do
    assert Year2021.Day07.part2 == 94862124
  end
end
