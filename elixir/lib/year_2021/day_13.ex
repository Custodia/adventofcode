defmodule AdventOfCode.Year2021.Day13 do
  @filename "../inputs/2021/day13.txt"

  def part1 do
    {coords, instructions} =
      File.read!(@filename)
      |> parse_input()

    fold(coords, List.first(instructions))
    |> Enum.count()
  end

  def part2 do
    {coords, instructions} =
      File.read!(@filename)
      |> parse_input()

    instructions
    |> Enum.reduce(coords, &fold(&2, &1))
    |> print()
  end

  def parse_input(input) do
    [coords, [""], instructions, [""]] =
      input
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.chunk_by(fn s -> s == "" end)

    coords =
      coords
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&Enum.map(&1, fn e -> String.to_integer(e) end))
      |> MapSet.new(&List.to_tuple/1)

    instructions =
      instructions
      |> Enum.map(&Regex.run(~r/(\w)=(\d+)/, &1, capture: :all_but_first))
      |> Enum.map(fn [c, d] -> {c, String.to_integer(d)} end)

    {coords, instructions}
  end

  def fold(coords, {axis, split}) do
    coords
    |> Enum.map(fn {x, y} ->
      cond do
        axis == "x" && x > split -> {split - (x - split), y}
        axis == "y" && y > split -> {x, split - (y - split)}
        true -> {x, y}
      end
    end)
    |> MapSet.new()
  end

  def print(coords) do
    {max_x, max_y} =
      Enum.reduce(coords, {0, 0}, fn {x, y}, {max_x, max_y} -> {max(x, max_x), max(y, max_y)} end)

    rows = for y <- 0..max_y do
      row = for x <- 0..max_x, do: if MapSet.member?(coords, {x, y}), do: "#", else: "."
      Enum.join(row)
    end
    Enum.join(rows, "\n")
  end
end
