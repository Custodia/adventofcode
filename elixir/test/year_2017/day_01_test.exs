defmodule AdventOfCode.Year2017.Day01Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2017

  test "part1" do
    assert Year2017.Day01.part1 == 1158
  end

  test "part2" do
    assert Year2017.Day01.part2 == 1132
  end
end
