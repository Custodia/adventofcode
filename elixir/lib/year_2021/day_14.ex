defmodule AdventOfCode.Year2021.Day14 do
  @filename "../inputs/2021/day14.txt"

  def part1 do
    {polymer, rules} = File.read!(@filename) |> parse_input()

    get_processed_polymer_char_counts(polymer, rules, 10)
    |> Enum.min_max_by(&elem(&1, 1))
    |> then(fn {{_, min}, {_, max}} -> max - min end)
  end

  def part2 do
    {polymer, rules} = File.read!(@filename) |> parse_input()

    get_processed_polymer_char_counts(polymer, rules, 40)
    |> Enum.min_max_by(&elem(&1, 1))
    |> then(fn {{_, min}, {_, max}} -> max - min end)
  end

  def parse_input(input) do
    [polymer | pair_insertion_rules] = String.split(input, "\n", trim: :true)

    pair_insertion_rules =
      pair_insertion_rules
      |> Enum.map(&String.graphemes/1)
      |> Map.new(fn [a, b, _, _, _, _, c] -> {{a, b}, [{a, c}, {c, b}]} end)

    {polymer, pair_insertion_rules}
  end

  def get_processed_polymer_char_counts(polymer, pair_insertion_rules, steps) do
    <<first::binary-size(1)>> <> _ = polymer
    polymer_pair_counts = get_polymer_pair_counts(polymer)

    1..steps
    |> Enum.reduce(polymer_pair_counts, fn _, polymer_pair_counts ->
      process_polymer_pair_counts(polymer_pair_counts, pair_insertion_rules)
    end)
    |> Enum.map(fn {{_, b}, count} -> {b, count} end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Map.new(fn {c, counts} -> {c, Enum.sum(counts)} end)
    |> Map.update(first, 1, &(&1 + 1))
  end

  def get_polymer_pair_counts(polymer) do
    String.graphemes(polymer)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.frequencies()
  end

  def process_polymer_pair_counts(polymer_pair_counts, pair_insertion_rules) do
    polymer_pair_counts
    |> Enum.flat_map(fn {pair, count} ->
      results = Map.fetch!(pair_insertion_rules, pair)
      Enum.map(results, fn result -> {result, count} end)
    end)
    |> Enum.reduce(%{}, fn {pair, count}, polymer_pair_counts ->
      Map.update(polymer_pair_counts, pair, count, &(&1 + count))
    end)
  end
end
