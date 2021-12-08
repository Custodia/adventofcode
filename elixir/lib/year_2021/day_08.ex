defmodule AdventOfCode.Year2021.Day08 do
  @filename "../inputs/2021/day08.txt"

  @possible_chars String.graphemes("abcdefg")

  def part1 do
    File.stream!(@filename)
    |> parse_input()
    |> Stream.flat_map(&elem(&1, 1))
    |> Stream.map(&Enum.count/1)
    |> Stream.filter(&(&1 in [2, 3, 4, 7]))
    |> Enum.count()
  end

  def part2 do
    File.stream!(@filename)
    |> parse_input()
    |> Stream.map(&solve_row/1)
    |> Enum.sum()
  end

  def solve_row({hints, displays}) do
    possible_mappings = Map.new(@possible_chars, fn c -> {c, @possible_chars} end)

    real_mappings =
      possible_mappings
      |> fit_n1(hints)
      |> fit_n7(hints)
      |> fit_n4(hints)
      |> fit_ns_069(hints)
      |> Map.new(fn {from, [to]} -> {from, to} end)

    displays
    |> Enum.map(fn display ->
      display
      |> Enum.map(&Map.fetch!(real_mappings, &1))
      |> Enum.sort()
      |> Enum.join()
    end)
    |> Enum.map(&signals_to_integer/1)
    |> Integer.undigits()
  end

  def fit_n1(possible_mappings, hints) do
    real_chars = String.graphemes("cf")
    matched_chars = [_, _] = Enum.find(hints, &(Enum.count(&1) == 2))

    fit_possible_mappings(possible_mappings, matched_chars, real_chars)
  end

  def fit_n7(possible_mappings, hints) do
    real_chars = String.graphemes("acf")
    matched_chars = [_, _, _] = Enum.find(hints, &(Enum.count(&1) == 3))

    fit_possible_mappings(possible_mappings, matched_chars, real_chars)
  end

  def fit_n4(possible_mappings, hints) do
    real_chars = String.graphemes("bcdf")
    matched_chars = [_, _, _, _] = Enum.find(hints, &(Enum.count(&1) == 4))

    fit_possible_mappings(possible_mappings, matched_chars, real_chars)
  end

  def fit_ns_069(possible_mappings, hints) do
    real_in_common_chars = String.graphemes("abfg")
    in_common_chars = [_, _, _, _] =
      hints
      |> Enum.filter(&(Enum.count(&1) == 6))
      |> Enum.concat()
      |> Enum.frequencies()
      |> Enum.filter(fn {_, count} -> count == 3 end)
      |> Enum.map(&elem(&1, 0))

    fit_possible_mappings(possible_mappings, in_common_chars, real_in_common_chars)
  end

  def fit_possible_mappings(possible_mappings, mixed_chars, real_chars) do
    possible_mappings
    |> Enum.map(fn {c, possible} ->
      if c in mixed_chars do
        {c, Enum.filter(possible, &(&1 in real_chars))}
      else
        {c, Enum.reject(possible, &(&1 in real_chars))}
      end
    end)
    |> Map.new()
  end

  def parse_input(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Stream.flat_map(&String.split(&1, " | "))
    |> Stream.flat_map(&String.split(&1, " "))
    |> Stream.map(&String.graphemes/1)
    |> Stream.chunk_every(14)
    |> Stream.map(&Enum.chunk_every(&1, 10))
    |> Stream.map(&List.to_tuple/1)
  end

  def signals_to_integer(signals) do
    case signals do
      "abcefg"  -> 0
      "cf"      -> 1
      "acdeg"   -> 2
      "acdfg"   -> 3
      "bcdf"    -> 4
      "abdfg"   -> 5
      "abdefg"  -> 6
      "acf"     -> 7
      "abcdefg" -> 8
      "abcdfg"  -> 9
    end
  end
end
