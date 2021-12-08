defmodule AdventOfCode.Year2017.Day02 do
  @filename "../inputs/2017/day02.txt"

  def part1 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "\t"))
    |> Stream.map(&Enum.map(&1, fn e -> String.to_integer(e) end))
    |> Stream.map(&Enum.min_max/1)
    |> Stream.map(fn {min, max} -> max - min end)
    |> Enum.sum()
  end

  def part2 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "\t"))
    |> Stream.map(&Enum.map(&1, fn e -> String.to_integer(e) end))
    |> Stream.map(&get_evenly_divisible(&1, &1))
    |> Stream.map(fn [result] -> result end)
    |> Enum.sum()
  end

  def get_evenly_divisible(arr1, arr2) do
    for x <- arr1, y <- arr2, x != y && rem(x, y) == 0, do: div(x, y)
  end
end
