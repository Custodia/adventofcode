defmodule AdventOfCode.Year2021.Day03 do
  @filename "../inputs/2021/day03.txt"

  def part1 do
    lines =
      File.stream!(@filename)
      |> Stream.map(&String.trim/1)
      |> Enum.map(&String.graphemes/1)

    acc = List.first(lines) |> Enum.map(fn _ -> {0, 0} end)

    bit_counts =
      lines
      |> Enum.reduce(acc, fn bits, acc ->
        Enum.zip(bits, acc)
        |> Enum.map(fn {bit, {zeros, ones}} ->
          if bit == "0", do: {zeros + 1, ones}, else: {zeros, ones + 1}
        end)
      end)

    most_significant = get_most_significant(bit_counts)
    least_significant = get_least_significant(bit_counts)

    most_significant * least_significant
  end

  defp get_most_significant(bit_counts) do
    bit_counts
    |> Enum.map(fn {zeros, ones} ->
      if zeros > ones, do: "0", else: "1"
    end)
    |> Enum.join()
    |> Integer.parse(2)
    |> then(&elem(&1, 0))
  end

  defp get_least_significant(bit_counts) do
    bit_counts
    |> Enum.map(fn {zeros, ones} ->
      if zeros > ones, do: "1", else: "0"
    end)
    |> Enum.join()
    |> Integer.parse(2)
    |> then(&elem(&1, 0))
  end

  def part2 do
    lines =
      File.stream!(@filename)
      |> Stream.map(&String.trim/1)
      |> Enum.map(&String.graphemes/1)

    most_significant = solve_2_by_most_significant(lines)
    least_significant = solve_2_by_least_significant(lines)

    most_significant * least_significant
  end

  defp solve_2_by_most_significant(lines, index \\ 0)
  defp solve_2_by_most_significant([line], _index), do:
    Enum.join(line) |> Integer.parse(2) |> then(&elem(&1, 0))
  defp solve_2_by_most_significant(lines, index) do
    most_significant =
      Enum.reduce(lines, {0, 0}, fn line, {zeros, ones} ->
        if Enum.at(line, index) == "0", do: {zeros + 1, ones}, else: {zeros, ones + 1}
      end)
      |> then(fn {zeros, ones} -> if zeros > ones, do: "0", else: "1" end)

    new_lines = Enum.filter(lines, fn line -> Enum.at(line, index) == most_significant end)
    solve_2_by_most_significant(new_lines, index + 1)
  end

  defp solve_2_by_least_significant(lines, index \\ 0)
  defp solve_2_by_least_significant([line], _index), do:
    Enum.join(line) |> Integer.parse(2) |> then(&elem(&1, 0))
  defp solve_2_by_least_significant(lines, index) do
    least_significant =
      Enum.reduce(lines, {0, 0}, fn line, {zeros, ones} ->
        if Enum.at(line, index) == "0", do: {zeros + 1, ones}, else: {zeros, ones + 1}
      end)
      |> then(fn {zeros, ones} -> if zeros > ones, do: "1", else: "0" end)

    new_lines = Enum.filter(lines, fn line -> Enum.at(line, index) == least_significant end)
    solve_2_by_least_significant(new_lines, index + 1)
  end
end
