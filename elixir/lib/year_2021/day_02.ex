defmodule AdventOfCode.Year2021.Day02 do
  @filename "../2021/inputs/day02.txt"

  def part1 do
    result = File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(fn [command, n] -> {command, String.to_integer(n)} end)
    |> Enum.reduce({0, 0}, &update_position/2)
    |> then(fn {position, depth} -> position * depth end)
  end

  def part2 do
    result = File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(fn [command, n] -> {command, String.to_integer(n)} end)
    |> Enum.reduce({0, 0, 0}, &update_aimed_position/2)
    |> then(fn {position, depth, _aim} -> position * depth end)
  end

  defp update_position({"forward", n}, {position, depth}), do: {position + n, depth}
  defp update_position({"up", n}, {position, depth}), do: {position, depth - n}
  defp update_position({"down", n}, {position, depth}), do: {position, depth + n}

  defp update_aimed_position({"forward", n}, {position, depth, aim}), do:
    {position + n, depth + (n * aim), aim}
  defp update_aimed_position({"up", n}, {position, depth, aim}), do:
    {position, depth, aim - n}
  defp update_aimed_position({"down", n}, {position, depth, aim}), do:
    {position, depth, aim + n}
end
