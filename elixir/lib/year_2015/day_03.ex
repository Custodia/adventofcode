defmodule AdventOfCode.Year2015.Day03 do
  @filename "../inputs/2015/day03.txt"

  def part1 do
    File.stream!(@filename, [], 1)
    |> Stream.filter(fn c -> c in ["^", ">", "v", "<"] end)
    |> Enum.scan({0, 0}, &calculate_new_location/2)
    |> then(&([{0, 0} | &1]))
    |> Enum.uniq()
    |> Enum.count()
  end

  defp calculate_new_location(direction, {x, y}) do
    case direction do
      "^" -> {x, y + 1}
      "v" -> {x, y - 1}
      ">" -> {x + 1, y}
      "<" -> {x - 1, y}
    end
  end

  def part2 do
    santa = File.stream!(@filename, [], 1)
    |> Stream.filter(fn c -> c in ["^", ">", "v", "<"] end)
    |> Stream.with_index()
    |> Stream.filter(fn {_, i} -> rem(i, 2) == 0 end)
    |> Stream.map(&elem(&1, 0))
    |> Enum.scan({0, 0}, &calculate_new_location/2)

    robo_santa = File.stream!(@filename, [], 1)
    |> Stream.filter(fn c -> c in ["^", ">", "v", "<"] end)
    |> Stream.with_index()
    |> Stream.filter(fn {_, i} -> rem(i, 2) == 1 end)
    |> Stream.map(&elem(&1, 0))
    |> Enum.scan({0, 0}, &calculate_new_location/2)

    Enum.concat([[{0, 0}], santa, robo_santa])
    |> Enum.uniq()
    |> Enum.count()
  end
end
