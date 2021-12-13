defmodule AdventOfCode.Year2021.Day13Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2021

  test "part1" do
    assert Year2021.Day13.part1 == 743
  end

  test "part2" do
    assert Year2021.Day13.part2 == String.trim("""
    ###...##..###..#.....##..#..#.#..#.#...
    #..#.#..#.#..#.#....#..#.#.#..#..#.#...
    #..#.#....#..#.#....#..#.##...####.#...
    ###..#....###..#....####.#.#..#..#.#...
    #.#..#..#.#....#....#..#.#.#..#..#.#...
    #..#..##..#....####.#..#.#..#.#..#.####
    """)
  end
end
