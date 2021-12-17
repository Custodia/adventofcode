defmodule AdventOfCode.Year2021.Day15 do
  @filename "../inputs/2021/day15.txt"

  def part1 do
    {max_coords, danger_coords_list} = File.read!(@filename) |> parse_input()
    danger_map = danger_coords_list |> Enum.concat() |> Map.new()

    djikstra(danger_map, {0, 0}, max_coords, max_coords)
  end

  def part2 do
    {{max_x, max_y}, danger_coords_list} = File.read!(@filename) |> parse_input()
    danger_coords_list = quintuple_danger_coords_list(danger_coords_list, {max_x, max_y})
    danger_map = danger_coords_list |> Enum.concat() |> Map.new()
    max_coords = {max_x * 5 + 4, max_y * 5 + 4}

    djikstra(danger_map, {0, 0}, max_coords, max_coords)
  end

  def parse_input(input) do
    danger_coords_list =
      String.split(input, "\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {e, x} -> {{x, y}, String.to_integer(e)} end)
      end)

    {{max_x, max_y}, _} = List.last(List.last(danger_coords_list))

    {{max_x, max_y}, danger_coords_list}
  end

  def quintuple_danger_coords_list(danger_coords_list, {max_x, max_y}) do
    danger_coords_list
    |> Enum.map(fn row ->
      row
      |> List.duplicate(5)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, i} ->
        Enum.map(row, fn {{x, y}, e} ->
          new_coords = {(max_x + 1) * i + x, y}
          {new_coords, e + i}
        end)
      end)
    end)
    |> List.duplicate(5)
    |> Enum.with_index()
    |> Enum.flat_map(fn {rows, i} ->
      Enum.map(rows, fn row ->
        Enum.map(row, fn {{x, y}, e} ->
          new_coords = {x, (max_y + 1) * i + y}
          new_e = if e + i > 9, do: e + i - 9, else: e + i
          {new_coords, new_e}
        end)
      end)
    end)
  end

  def djikstra(danger_map, initial, target, {max_x, max_y}) do
    next_coords = get_adjacent_coords(initial, {max_x, max_y})
    max_value = (max_x + 1) * (max_y + 1) * 10
    untraversed = for x <- 0..max_x, y <- 0..max_y, into: %{} do
      coord = {x, y}
      cost = if coord in next_coords, do: 0, else: max_value
      {coord, cost}
    end

    djikstra(next_coords, untraversed, danger_map, target, {max_x, max_y})
  end

  defp djikstra([ target | _ ], untraversed, danger_map, target, _) do
    Map.fetch!(untraversed, target) + Map.fetch!(danger_map, target)
  end
  defp djikstra([ current | next_coords ], untraversed, danger_map, target, max_coords) do
    {cost, untraversed} = Map.pop!(untraversed, current)
    {danger, danger_map} = Map.pop!(danger_map, current)

    adjacent_coords =
      get_adjacent_coords(current, max_coords)
      |> Enum.filter(&Map.has_key?(untraversed, &1))

    untraversed =
      adjacent_coords
      |> Enum.reduce(untraversed, fn coord, untraversed ->
        Map.update!(untraversed, coord, fn e -> min(e, cost + danger) end)
      end)

    next_coords =
      Enum.concat(next_coords, adjacent_coords)
      |> Enum.uniq()
      |> Enum.sort_by(&Map.fetch(untraversed, &1))

    djikstra(next_coords, untraversed, danger_map, target, max_coords)
  end

  defp get_adjacent_coords({x, y}, {max_x, max_y}) do
    [{x, y+1}, {x+1, y}, {x, y-1}, {x-1, y}]
    |> Enum.reject(fn {x, y} -> x < 0 || y < 0 || x > max_x || y > max_y end)
  end
end
