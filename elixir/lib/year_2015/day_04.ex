defmodule AdventOfCode.Year2015.Day04 do
  @filename "../inputs/2015/day04.txt"

  def part1 do
    input = File.read!(@filename) |> String.trim()

    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(fn e -> {"#{input}#{e}", e} end)
    |> Stream.map(fn {e, i} -> {:crypto.hash(:md5 , e) |> Base.encode16(), i} end)
    |> Enum.find(fn {e, _i} -> String.starts_with?(e, "00000") end)
    |> elem(1)
  end

  def part2 do
    input = File.read!(@filename) |> String.trim()

    # Start from 9_000_000 to reduce on testing time
    Stream.iterate(9_000_000, &(&1 + 1))
    |> Stream.map(fn e -> {"#{input}#{e}", e} end)
    |> Stream.map(fn {e, i} -> {:crypto.hash(:md5 , e) |> Base.encode16(), i} end)
    |> Enum.find(fn {e, _i} -> String.starts_with?(e, "000000") end)
    |> elem(1)
  end
end
