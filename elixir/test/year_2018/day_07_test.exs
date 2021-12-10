defmodule AdventOfCode.Year2018.Day07Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2018

  test "part1" do
    assert Year2018.Day07.part1 == "OVXCKZBDEHINPFSTJLUYRWGAMQ"
  end

  test "part2" do
    assert Year2018.Day07.part2 == 955
  end
end
