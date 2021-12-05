defmodule AdventOfCode.Year2017.Day04 do
  @filename "../2017/inputs/day04.txt"

  def part1 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.filter(&(Enum.count(&1) == Enum.count(Enum.uniq(&1))))
    |> Enum.count()
  end

  def part2 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(&Enum.map(&1, fn e ->
      String.graphemes(e) |> Enum.sort() |> Enum.join()
    end))
    |> Stream.filter(&(Enum.count(&1) == Enum.count(Enum.uniq(&1))))
    |> Enum.count()
  end
end
