defmodule AdventOfCode.Year2020.Day01Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2020

  test "part1" do
    assert Year2020.Day01.part1 == 988771
  end

  test "part2" do
    assert Year2020.Day01.part2 == 171933104
  end
end
