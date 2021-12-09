defmodule AdventOfCode.Year2018.Day05 do
  @filename "../inputs/2018/day05.txt"

  def part1 do
    File.read!(@filename)
    |> String.trim()
    |> String.to_charlist()
    |> fully_react_polymer()
    |> Enum.count()
  end

  def fully_react_polymer(polymer) do
    reacted_polymer = react_polymer(polymer)
    if length(polymer) == length(reacted_polymer) do
      reacted_polymer
    else
      fully_react_polymer(reacted_polymer)
    end
  end

  def react_polymer(polymer, remaining \\ [])
  def react_polymer([a, b | tail], remaining) when abs(a - b) == 32, do:
    react_polymer(tail, remaining)
  def react_polymer([a, b | tail], remaining), do:
    react_polymer([ b | tail ], [ a | remaining ])
  def react_polymer([a], remaining), do:
    [ a | remaining ]
  def react_polymer([], remaining), do:
    remaining

  def part2 do
    input =
      File.read!(@filename)
      |> String.trim()
      |> String.to_charlist()

    ?A..?Z
    |> Stream.map(fn c -> [c, c + 32] end)
    |> Stream.map(fn chars ->
      input
      |> Enum.reject(&(&1 in chars))
      |> fully_react_polymer()
      |> Enum.count()
    end)
    |> Enum.min()
  end
end
