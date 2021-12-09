defmodule AdventOfCode.Year2021.Day09 do
  @filename "../inputs/2021/day09.txt"

  def part1 do
    height_map = File.stream!(@filename) |> parse_input()

    height_map
    |> Enum.filter(fn {{x, y}, e} ->
      [{x-1, y}, {x, y + 1}, {x+1, y}, {x, y-1}]
      |> Enum.all?(fn coord -> Map.get(height_map, coord, 10) > e end)
    end)
    |> Enum.map(fn {_coord, e} -> e + 1 end)
    |> Enum.sum()
  end

  def part2 do
    height_map = File.stream!(@filename) |> parse_input()

    height_map
    |> Enum.filter(fn {coord, e} ->
      coord
      |> get_adjacent_coords()
      |> Enum.all?(fn coord -> Map.get(height_map, coord, 10) > e end)
    end)
    |> Enum.map(fn {coord, _} -> calculate_basin_size(coord, height_map) end)
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(3)
    |> Enum.product()
  end

  def calculate_basin_size(coord, height_map) do
    calculate_basin_size([coord], Map.delete(height_map, coord), 0)
  end
  defp calculate_basin_size([], _height_map, size), do: size
  defp calculate_basin_size(coords, height_map, size) do
    {new_coords, new_height_map} =
      coords
      |> Enum.flat_map(&get_adjacent_coords/1)
      |> Enum.reduce({[], height_map}, fn coord, {new_coords, new_height_map} ->
        case Map.pop(new_height_map, coord, 9) do
          {9, updated_map} -> {new_coords, updated_map}
          {_, updated_map} -> {[coord | new_coords], updated_map}
        end
      end)
    calculate_basin_size(new_coords, new_height_map, size + Enum.count(coords))
  end

  defp get_adjacent_coords({x, y}), do:
    [{x-1, y}, {x, y + 1}, {x+1, y}, {x, y-1}]

  def parse_input(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.map(&Integer.digits/1)
    |> Stream.with_index()
    |> Stream.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {e , x} -> {{x, y}, e} end)
    end)
    |> Map.new()
  end
end
