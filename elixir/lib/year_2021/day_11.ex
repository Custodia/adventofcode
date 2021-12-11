defmodule AdventOfCode.Year2021.Day11 do
  @filename "../inputs/2021/day11.txt"

  def part1 do
    octopus_map = File.stream!(@filename) |> parse_input()

    1..100
    |> Enum.reduce({octopus_map, 0}, fn _, {octopus_map, count} ->
      {new_octopus_map, flashes} = step_octopus_map(octopus_map)

      {new_octopus_map, count + flashes}
    end)
    |> elem(1)
  end

  def part2 do
    octopus_map = File.stream!(@filename) |> parse_input()

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(octopus_map, fn i, octopus_map ->
      case step_octopus_map(octopus_map) do
        {_new_octopus_map, 100} -> {:halt, i}
        {new_octopus_map, _} -> {:cont, new_octopus_map}
      end
    end)
  end

  def parse_input(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&Enum.map(&1, fn c -> String.to_integer(c) end))
    |> Stream.with_index()
    |> Stream.flat_map(fn {line, y} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn {e, x} -> {{x, y}, e} end)
    end)
    |> Map.new()
  end

  def step_octopus_map(octopus_map) do
    {octopuses, flash_coords} = Enum.map_reduce(octopus_map, [], fn {coord, v}, flash_coords ->
      case v do
        9 -> {{coord, v + 1}, [coord | flash_coords]}
        _ -> {{coord, v + 1}, flash_coords}
      end
    end)

    react_octopuses(Map.new(octopuses), flash_coords, length(flash_coords))
  end

  def react_octopuses(octopus_map, [], 0), do: {octopus_map, 0}
  def react_octopuses(octopus_map, [], count) do
    new_octopus_map =
      octopus_map
      |> Enum.map(fn {coord, v} ->
        new_v = if v >= 10, do: 0, else: v
        {coord, new_v}
      end)
      |> Map.new()

    {new_octopus_map, count}
  end
  def react_octopuses(octopus_map, flash_coords, count) do
    {octopuses, new_flash_coords} =
      flash_coords
      |> Enum.flat_map(&get_adjacent_coords/1)
      |> Enum.reduce({octopus_map, []}, fn coord, {octopus_map, flash_coords} ->
        case Map.fetch!(octopus_map, coord) do
          9 -> {Map.update!(octopus_map, coord, &(&1 + 1)), [coord | flash_coords]}
          v when v > 9 -> {octopus_map, flash_coords}
          _ -> {Map.update!(octopus_map, coord, &(&1 + 1)), flash_coords}
        end
      end)

    new_octopus_map = Map.new(octopuses)
    new_count = count + length(new_flash_coords)
    react_octopuses(new_octopus_map, new_flash_coords, new_count)
  end

  def get_adjacent_coords({x, y}) do
    coords = for xi <- x-1..x+1, yi <- y-1..y+1, x != xi or y != yi, do: {xi, yi}
    coords
    |> Enum.filter(fn {xi, yi} -> xi >= 0 && xi <= 9 && yi >= 0 && yi <= 9 end)
  end
end
