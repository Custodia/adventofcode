defmodule AdventOfCode.Year2017.Day02Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2017

  test "part1" do
    assert Year2017.Day02.part1 == 42299
  end

  test "part2" do
    assert Year2017.Day02.part2 == 277
  end
end
