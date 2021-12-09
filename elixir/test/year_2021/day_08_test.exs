defmodule AdventOfCode.Year2021.Day08Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2021

  test "part1" do
    assert Year2021.Day08.part1 == 355
  end

  test "part2" do
    assert Year2021.Day08.part2 == 983030
  end
end
