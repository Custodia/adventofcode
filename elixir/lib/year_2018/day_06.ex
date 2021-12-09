defmodule AdventOfCode.Year2018.Day06 do
  @filename "../inputs/2018/day06.txt"

  def part1 do
    coords = File.stream!(@filename) |> parse_input()
    coords_with_index = Enum.with_index(coords)

    {min_x, min_y} =
      Enum.reduce(coords, fn {x, y}, {mx, my} -> {min(x, mx), min(y, my)} end)
    {max_x, max_y} =
      Enum.reduce(coords, fn {x, y}, {mx, my} -> {max(x, mx), max(y, my)} end)

    grid_coords = for x <- min_x..max_x, y <- min_y..max_y do
      coords_with_index
      |> Enum.map(fn {{cx, cy}, i} -> {i, abs(cx - x) + abs(cy - y)} end)
      |> Enum.sort_by(fn {_, v} -> v end)
      |> then(fn [{i1, v1}, {_, v2} | _] ->
        if v1 != v2, do: i1, else: nil
      end)
      |> then(fn i -> {{x, y}, i} end)
    end

    infinite_indexes =
      grid_coords
      |> Stream.filter(fn {{x, y}, _} -> x in [min_x, max_x] || y in [min_y, max_y] end)
      |> Stream.map(fn {_coord, i} -> i end)
      |> Enum.uniq()

    grid_coords
    |> Stream.map(fn {_coord, i} -> i end)
    |> Stream.reject(fn i -> i == nil end)
    |> Stream.reject(fn i -> i in infinite_indexes end)
    |> Enum.frequencies()
    |> Enum.map(fn {_i, c} -> c end)
    |> Enum.max()
  end

  def part2 do
    coords = File.stream!(@filename) |> parse_input()

    {min_x, min_y} =
      Enum.reduce(coords, fn {x, y}, {mx, my} -> {min(x, mx), min(y, my)} end)
    {max_x, max_y} =
      Enum.reduce(coords, fn {x, y}, {mx, my} -> {max(x, mx), max(y, my)} end)

    grid_sums = for x <- min_x..max_x, y <- min_y..max_y do
      coords
      |> Enum.map(fn {cx, cy} -> abs(cx - x) + abs(cy - y) end)
      |> Enum.sum()
    end

    grid_sums
    |> Enum.filter(&(&1 < 10000))
    |> Enum.count()
  end

  def parse_input(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ", "))
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)}end)
  end
end
