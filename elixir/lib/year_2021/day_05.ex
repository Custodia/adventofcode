defmodule AdventOfCode.Year2021.Day05 do
  @filename "../2021/inputs/day05.txt"

  def part1 do
    File.stream!(@filename)
    |> parse_input()
    |> Stream.filter(fn {{x1, y1}, {x2, y2}} -> x1 == x2 || y1 == y2 end)
    |> Stream.flat_map(&get_coordinates_from_range/1)
    |> Enum.reduce(%{}, fn coord, acc -> Map.update(acc, coord, 1, fn c -> c + 1 end) end)
    |> Enum.filter(fn {_coord, count} -> count > 1 end)
    |> Enum.count()
  end

  def part2 do
    File.stream!(@filename)
    |> parse_input()
    |> Stream.flat_map(&get_coordinates_from_range/1)
    |> Enum.reduce(%{}, fn coord, acc -> Map.update(acc, coord, 1, fn c -> c + 1 end) end)
    |> Enum.filter(fn {_coord, count} -> count > 1 end)
    |> Enum.count()
  end

  def parse_input(input) do
    Stream.map(input, &parse_input_line/1)
  end

  def get_coordinates_from_range({{x1, y1}, {x2, y2}}) when x1 == x2 or y1 == y2 do
    for x <- x1..x2, y <- y1..y2, do: {x, y}
  end
  def get_coordinates_from_range({{x1, y1}, {x2, y2}}) do
    diff = abs(x1 - x2)
    for i <- 0..diff do
      x = if x1 > x2, do: x1 - i, else: x1 + i
      y = if y1 > y2, do: y1 - i, else: y1 + i
      {x, y}
    end
  end

  def parse_input_line(line) do
    line
    |> String.trim()
    |> String.split(" -> ")
    |> Enum.flat_map(&String.split(&1, ","))
    |> Enum.map(&String.to_integer/1)
    |> then(fn [x1, y1, x2, y2] -> {{x1, y1}, {x2, y2}} end)
  end
end
