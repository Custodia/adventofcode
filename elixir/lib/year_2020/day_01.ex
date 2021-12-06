defmodule AdventOfCode.Year2020.Day01 do
  @filename "../2020/inputs/day01.txt"

  def part1 do
    File.stream!(@filename)
    |> parse_input()
    |> find_two_that_sum()
    |> then(fn {x, y} -> x * y end)
  end

  def part2 do
    File.stream!(@filename)
    |> parse_input()
    |> find_three_that_sum()
    |> then(fn {x, y, z} -> x * y * z end)
  end

  def find_two_that_sum(numbers, target \\ 2020) do
    combinations = for x <- numbers, y <- numbers, x != y, do: {x, y}

    Enum.find(combinations, fn {x, y} -> x + y == 2020 end)
  end

  def find_three_that_sum(numbers, target \\ 2020) do
    combinations = for x <- numbers, y <- numbers, z <- numbers, x != y and x != z and y != z, do: {x, y, z}

    Enum.find(combinations, fn {x, y, z} -> x + y + z == 2020 end)
  end

  def parse_input(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end
end
