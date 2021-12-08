defmodule AdventOfCode.Year2015.Day02 do
  @filename "../inputs/2015/day02.txt"

  def part1 do
    File.stream!(@filename)
    |> then(&parse_input_file_stream/1)
    |> Stream.map(fn [x, y, z] -> [x*y, x*z, y*z] end)
    |> Stream.map(fn [a, b, c] -> 2*a + 2*b + 2*c + Enum.min([a, b, c]) end)
    |> Enum.sum()
  end

  def part2 do
    File.stream!(@filename)
    |> then(&parse_input_file_stream/1)
    |> Stream.map(fn dimensions ->
      circumerence = Enum.sort(dimensions) |> Enum.take(2) |> Enum.map(&(&1 * 2)) |> Enum.sum
      ribbon = Enum.product(dimensions)
      circumerence + ribbon
    end)
    |> Enum.sum()
  end

  defp parse_input_file_stream(file_stream) do
    file_stream
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "x"))
    |> Stream.map(&Enum.map(&1, fn e -> String.to_integer(e) end))
  end
end
