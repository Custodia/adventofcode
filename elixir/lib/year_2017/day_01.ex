defmodule AdventOfCode.Year2017.Day01 do
  @filename "../2017/inputs/day01.txt"

  def part1 do
    File.stream!(@filename, [], 1)
    |> Stream.filter(fn c -> c != "\n" end)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [head | tail] -> [head | tail] ++ [head] end)
    |> then(&sum_matching/1)
  end

  defp sum_matching(list, sum \\ 0)
  defp sum_matching([], sum), do: sum
  defp sum_matching([_], sum), do: sum
  defp sum_matching([v, v | tail], sum), do: sum_matching([v | tail], sum + v)
  defp sum_matching([_head | tail], sum), do: sum_matching(tail, sum)

  def part2 do
    digits = File.stream!(@filename, [], 1)
    |> Stream.filter(fn c -> c != "\n" end)
    |> Enum.map(&String.to_integer/1)

    digit_length = Enum.count(digits)
    shift = div(digit_length, 2)
    shifted_digits = Enum.drop(digits, shift) ++ Enum.take(digits, shift)

    Enum.zip(digits, shifted_digits)
    |> Enum.reduce(0, fn {x, y}, acc -> if x == y, do: acc + x, else: acc end)
  end
end
