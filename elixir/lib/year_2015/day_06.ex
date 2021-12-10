defmodule AdventOfCode.Year2015.Day06 do
  @filename "../inputs/2015/day06.txt"

  @line_regex ~r/(turn off|turn on|toggle) (\d+),(\d+) through (\d+),(\d+)/

  def part1 do
    row = List.duplicate(false, 1000)
    grid = List.duplicate(row, 1000)

    File.stream!(@filename)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce(grid, fn {instruction, from, to}, grid ->
      update_boolean_grid(grid, instruction, from, to)
    end)
    |> Enum.flat_map(&Enum.filter(&1, fn x -> x end))
    |> Enum.count()
  end

  def part2 do
    row = List.duplicate(0, 1000)
    grid = List.duplicate(row, 1000)

    File.stream!(@filename)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce(grid, fn {instruction, from, to}, grid ->
      update_integer_grid(grid, instruction, from, to)
    end)
    |> Enum.map(&Enum.sum(&1))
    |> Enum.sum()
  end

  def parse_instruction(line) do
    [instruction | coords] = Regex.run(@line_regex, line, capture: :all_but_first)
    [x1, y1, x2, y2] = Enum.map(coords, &String.to_integer/1)
    {instruction, {x1, y1}, {x2, y2}}
  end

  def update_boolean_grid(grid, instruction, {x1, y1}, {x2, y2}) do
    func = case instruction do
      "turn on"  -> fn _ -> true end
      "turn off" -> fn _ -> false end
      "toggle"   -> fn e -> !e end
    end
    grid
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      if y >= y1 and y <= y2 do
        line
        |> Enum.with_index()
        |> Enum.map(fn {e, x} -> if x >= x1 and x <= x2, do: func.(e), else: e end)
      else
        line
      end
    end)
  end

  def update_integer_grid(grid, instruction, {x1, y1}, {x2, y2}) do
    func = case instruction do
      "turn on"  -> fn e -> e + 1 end
      "turn off" -> fn e -> if e == 0, do: e, else: e - 1 end
      "toggle"   -> fn e -> e + 2 end
    end
    grid
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      if y >= y1 and y <= y2 do
        line
        |> Enum.with_index()
        |> Enum.map(fn {e, x} -> if x >= x1 and x <= x2, do: func.(e), else: e end)
      else
        line
      end
    end)
  end
end
