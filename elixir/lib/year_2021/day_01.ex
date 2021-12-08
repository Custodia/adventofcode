defmodule AdventOfCode.Year2021.Day01 do
  @filename "../inputs/2021/day01.txt"

  def part1 do
    result = File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.reduce({-1, -1}, fn e, {prev, count} ->
      if e > prev, do: {e, count + 1}, else: {e, count}
    end)
    |> then(&elem(&1, 1))
    result
  end

  def part2 do
    result = File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> then(&count_sliding_windows/1)
    |> Enum.reduce({-1, -1}, fn e, {prev, count} ->
      if e > prev, do: {e, count + 1}, else: {e, count}
    end)
    |> then(&elem(&1, 1))
    result
  end

  defp count_sliding_windows([first, second | tail]) do
    Enum.map_reduce(tail, {first, second}, fn e, {f, s} -> {e + f + s, {e, f}} end)
    |> then(&elem(&1, 0))
  end
end
