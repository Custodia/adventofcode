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

    Enum.find(combinations, fn {x, y} -> x + y == target end)
  end
  def find_two_that_sum([], [], _target), do: nil
  def find_two_that_sum([_], _, _target), do: nil
  def find_two_that_sum([_a1, a2 | atail], [], target), do:
    find_two_that_sum([a2 | atail], atail, target)
  def find_two_that_sum([a | _], [b | _], target) when a + b == target, do:
    {a, b}
  def find_two_that_sum([a | atail], [b | btail], target) when a + b > target, do:
    find_two_that_sum([a | atail], btail, target)
  def find_two_that_sum([_a1, a2 | atail], _, target), do:
    find_two_that_sum([a2 | atail], atail, target)

  defp find_three_that_sum([n | number_tail], target \\ 2020) do
    case find_two_that_sum(number_tail, target - n) do
      nil -> find_three_that_sum(number_tail, target)
      {x, y} -> {x, y, n}
    end
  end

  def parse_input(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sort(&>=/2)
  end
end
