defmodule AdventOfCode.Year2017.Day03 do
  @filename "../inputs/2017/day03.txt"

  def part1 do
    input = get_input()
    {x, y} = get_coordinates(input)
    abs(x) + abs(y)
  end

  def get_coordinates(n) do
    layer = get_layer(n)
    x = 1 + layer * 2
    xx = x * x
    count_in_layer = n - xx
    layer_coordinates = get_layer_coordinates({-layer, layer})
    Enum.at(layer_coordinates, count_in_layer - 1)
  end

  defp get_layer(n, layer \\ 0) do
    x = 1 + layer * 2
    xx = x * x
    cond do
      n <= xx -> layer
      true -> get_layer(n, layer + 1)
    end
  end

  def get_layer_coordinates({s, s}), do: [{s, s}]
  def get_layer_coordinates({s, e}) do
    first  = for x <- e..e, y <- s+1..e, do: {x, y}
    second = for x <- e-1..s, y <- e..e, do: {x, y}
    third  = for x <- s..s, y <- e-1..s, do: {x, y}
    fourth = for x <- s+1..e, y <- s..s, do: {x, y}
    List.flatten([ first, second, third, fourth ])
  end

  def part2 do
    input = get_input()

    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(fn layer -> {-layer, layer} end)
    |> Stream.flat_map(&get_layer_coordinates/1)
    |> Enum.reduce_while(%{}, &reduce_part2(&1, &2, input))
  end

  defp reduce_part2({0, 0}, %{}, max) do
    {:cont, Map.put(%{}, {0, 0}, 1)}
  end
  defp reduce_part2({x, y}, coord_map, max) do
    neighbors = for xi <- x-1..x+1, yi <- y-1..y+1, xi != x || yi != y, do: {xi, yi}
    neighbor_sum =
      neighbors
      |> Enum.map(&Map.get(coord_map, &1, 0))
      |> Enum.sum()

    if neighbor_sum >= max do
      {:halt, neighbor_sum}
    else
      {:cont, Map.put(coord_map, {x, y}, neighbor_sum)}
    end
  end

  def get_input do
    File.read!(@filename) |> String.trim() |> String.to_integer()
  end
end
