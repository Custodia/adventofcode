defmodule AdventOfCode.Year2021.Day12 do
  @filename "../inputs/2021/day12.txt"

  def part1 do
    File.stream!(@filename)
    |> parse_input()
    |> get_paths("start", [], false)
    |> Enum.count()
  end

  def part2 do
    File.stream!(@filename)
    |> parse_input()
    |> get_paths("start", [], true)
    |> Enum.count()
  end

  def parse_input(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "-"))
    |> Stream.flat_map(fn [from, to] -> [[from, to], [to, from]] end)
    |> Enum.group_by(&Enum.at(&1, 0), &Enum.at(&1, 1))
  end

  def get_paths(_, "end", traversed, _), do: [Enum.reverse(["end" | traversed])]
  def get_paths(connections, "start", _traversed, can_revisit?) do
    new_connections =
      connections
      |> then(&Map.drop(&1, ["start", "end"]))
      |> map_values(&Enum.filter(&1, fn e -> e != "start" end))

    Map.get(connections, "start", [])
    |> Enum.map(&get_paths(new_connections, &1, ["start"], can_revisit?))
    |> Enum.concat()
  end
  def get_paths(connections, current, traversed, true) do
    big_cave? = current != String.downcase(current)
    is_repeat? = !big_cave? && Enum.any?(traversed, &(&1 == current))
    other_traversed =
      traversed
      |> Enum.filter(&(&1 == String.downcase(&1)))
      |> Enum.filter(&(&1 != current))

    new_connections =
      connections
      |> then(&(if is_repeat?, do: Map.drop(&1, other_traversed), else: &1))
      |> map_values(&Enum.reject(&1, fn e -> is_repeat? && e in other_traversed end))
      |> map_values(&Enum.reject(&1, fn e -> is_repeat? && e == current end))

    Map.get(new_connections, current, [])
    |> Enum.map(&get_paths(new_connections, &1, [current | traversed], !is_repeat?))
    |> Enum.concat()
  end
  def get_paths(connections, current, traversed, false) do
    big_cave? = current != String.downcase(current)

    new_connections =
      connections
      |> then(&(if big_cave?, do: &1, else: Map.delete(&1, current)))
      |> map_values(&Enum.filter(&1, fn e -> big_cave? || e != current end))

    Map.get(connections, current, [])
    |> Enum.map(&get_paths(new_connections, &1, [current | traversed], false))
    |> Enum.concat()
  end

  def map_values(map, func) do
    Enum.map(map, fn {i, e} -> {i, func.(e)} end)
    |> Map.new()
  end
end
