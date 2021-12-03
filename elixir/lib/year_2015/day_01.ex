defmodule AdventOfCode.Year2015.Day01 do
  @filename "../2015/inputs/day01.txt"

  def part1 do
    File.stream!(@filename, [], 1)
    |> Enum.reduce(0, fn c, floor ->
      case c do
        "(" -> floor + 1
        ")" -> floor - 1
        _ -> floor
      end
    end)
  end

  def part2 do
    File.stream!(@filename, [], 1)
    |> Stream.with_index(1)
    |> Enum.reduce_while(0, fn {c, index}, floor ->
      case {c, floor} do
        {"(", _,} -> {:cont, floor + 1}
        {")", 0,} -> {:halt, index}
        {")", _,} -> {:cont, floor - 1}
        _ -> floor
      end
    end)
  end
end
