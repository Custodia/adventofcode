defmodule AdventOfCode.Year2015.Day06Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2015

  test "part1" do
    assert Year2015.Day06.part1 == 543903
  end

  test "part2" do
    assert Year2015.Day06.part2 == 14687245
  end
end
