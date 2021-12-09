defmodule AdventOfCode.Year2017.Day03Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2017

  test "part1" do
    assert Year2017.Day03.part1 == 480
  end

  test "part2" do
    assert Year2017.Day03.part2 == 349975
  end

  test "get_coordinates" do
    assert Year2017.Day03.get_coordinates(1) == {0, 0}
    assert Year2017.Day03.get_coordinates(12) == {2, 1}
  end
end
