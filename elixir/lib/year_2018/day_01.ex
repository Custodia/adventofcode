defmodule AdventOfCode.Year2018.Day01 do
  @filename "../inputs/2018/day01.txt"

  def part1 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part2 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.cycle()
    |> Stream.scan(&(&1 + &2))
    |> Enum.reduce_while(MapSet.new(), fn e, acc ->
      if MapSet.member?(acc, e) do
        {:halt, e}
      else
        {:cont, MapSet.put(acc, e)}
      end
    end)
  end
end
