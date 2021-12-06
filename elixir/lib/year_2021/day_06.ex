defmodule AdventOfCode.Year2021.Day06 do
  @filename "../2021/inputs/day06.txt"

  def part1 do
    File.read!(@filename)
    |> parse_input()
    |> advance_days(80)
    |> Enum.sum()
  end

  def part2 do
    File.read!(@filename)
    |> parse_input()
    |> advance_days(256)
    |> Enum.sum()
  end

  def advance_days(state, 0), do: state
  def advance_days([head | tail], days) do
    new_days = tail
    |> List.update_at(6, fn x -> x + head end)
    |> then(fn x -> x ++ [head] end)

    advance_days(new_days, days - 1)
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {i, elems} -> {i, Enum.count(elems)} end)
    |> Enum.reduce(List.duplicate(0, 9), fn {i, c}, acc ->
      List.replace_at(acc, i, c)
    end)
  end
end
