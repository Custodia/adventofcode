defmodule AdventOfCode.Year2015.Day05 do
  @filename "../inputs/2015/day05.txt"

  @vowels ["a", "e", "i", "o", "u"]

  def part1 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.reject(fn line -> String.match?(line, ~r/(ab|cd|pq|xy)/) end)
    |> Stream.map(&String.graphemes/1)
    |> Stream.filter(fn chars ->
      chars
      |> Enum.filter(&(&1 in @vowels))
      |> then(&(length(&1) >= 3))
    end)
    |> Stream.filter(fn chars ->
      chars
      |> Enum.chunk_by(fn x -> x end)
      |> Enum.map(&Enum.count/1)
      |> Enum.max()
      |> then(&(&1 > 1))
    end)
    |> Enum.count()
  end

  def part2 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.filter(fn chars ->
      chars
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.any?(fn [a, _, c] -> a == c end)
    end)
    |> Stream.filter(fn chars ->
      chars
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.with_index()
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.map(&elem(&1, 1))
      |> Enum.any?(fn list ->
        case list do
          [_, _, _ | _] -> true
          [a, b] -> a != b - 1
          _ -> false
        end
      end)
    end)
    |> Enum.count()
  end
end
