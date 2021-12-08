defmodule AdventOfCode.Year2021.Day07 do
  @filename "../inputs/2021/day07.txt"

  def part1 do
    numbers = File.read!(@filename) |> parse_input()
    {min, max} = Enum.min_max(numbers)

    min..max
    |> Enum.map(fn x ->
      distance = Enum.reduce(numbers, 0, fn y, acc -> abs(x - y) + acc end)
      {x, distance}
    end)
    |> Enum.min_by(fn {_, distance} -> distance end)
    |> then(fn {_, distance} -> distance end)
  end

  def part2 do
    numbers = File.read!(@filename) |> parse_input()
    {min, max} = Enum.min_max(numbers)
    crab_distances =
      min..max
      |> Stream.with_index()
      |> Enum.scan({0, 0}, fn {_, i}, {_, acc} -> {i, acc + i} end)
      |> Map.new()

    min..max
    |> Enum.map(fn x ->
      distance = Enum.reduce(numbers, 0, fn y, acc ->
        Map.get(crab_distances, abs(x - y)) + acc
      end)
      {x, distance}
    end)
    |> Enum.min_by(fn {_, distance} -> distance end)
    |> then(fn {_, distance} -> distance end)
  end

  def crab_distance(x, y) do
    x..y
    |> Stream.scan(0, fn _, acc -> acc + 1 end)
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
