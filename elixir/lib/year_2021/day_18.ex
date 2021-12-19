defmodule AdventOfCode.Year2021.Day18 do
  @filename "../inputs/2021/day18.txt"

  def part1 do
    File.read!(@filename)
    |> parse_input()
    |> sum_snail_sums()
    |> magnitude()
  end

  def part2 do
    snail_numbers = File.read!(@filename) |> parse_input()

    (for a <- snail_numbers, b <- snail_numbers, a != b, do: snail_sum(a, b))
    |> Stream.map(&reduce/1)
    |> Stream.map(&magnitude/1)
    |> Enum.max()
  end

  def parse_input(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&Code.eval_string/1)
    |> Enum.map(fn {snail_number, []} -> snail_number end)
  end

  def sum_snail_sums(snail_sums) do
    Enum.reduce(snail_sums, fn a, b ->
      snail_sum(b, a) |> reduce()
    end)
  end

  def snail_sum(a, b) do
    [a, b]
  end

  def reduce(snail_sum) do
    with ^snail_sum <- explode(snail_sum),
         ^snail_sum <- split(snail_sum)
    do
      snail_sum
    else
      new_snail_sum -> reduce(new_snail_sum)
    end
  end

  def explode(snail_number) do
    case explode(snail_number, 0) do
      {rem, result} when is_integer(rem) -> result
      {result, rem} when is_integer(rem) -> result
      result -> result
    end
  end
  defp explode(snail_number = [_, _], 3) do
    case snail_number do
      [[a, b], [c, d]] -> {a, [0, [b + c, d]]}
      [[a, b], c] -> {a, [0, b + c]}
      [a, [b, c]] -> {[a + b, 0], c}
      [a, b] when is_integer(a) and is_integer(b) -> [a, b]
    end
  end
  defp explode([a, b], depth) do
    result = [explode(a, depth + 1), explode(b, depth + 1)]
    case result do
      [{rem, na}, _] when is_integer(rem) ->
        {rem, [na, b]}
      [{na, rem}, _] when is_integer(rem) ->
        [na, add_to_left_most(b, rem)]
      [^a, {rem, nb}] when is_integer(rem) ->
        [add_to_right_most(a, rem), nb]
      [^a, {nb, rem}] when is_integer(rem) ->
        {[a, nb], rem}
      [^a, ^b] -> [a, b]
      [^a, nb] -> [a, nb]
      [na, ^b] -> [na, b]
      [na, _b] -> [na, b]
    end
  end
  defp explode(a, _depth) when is_integer(a) do
    a
  end

  def add_to_left_most([a, b], rem) do
    [add_to_left_most(a, rem), b]
  end
  def add_to_left_most(a, rem) do
    a + rem
  end

  def add_to_right_most([a, b], rem) do
    [a, add_to_right_most(b, rem)]
  end
  def add_to_right_most(a, rem) do
    a + rem
  end

  def split(a) when is_number(a), do:
    if a < 10, do: a, else: [floor(a / 2), ceil(a / 2)]
  def split([a, b]) do
    case [split(a), split(b)] do
      [^a, ^b] -> [a, b]
      [^a, nb] -> [a, nb]
      [na, ^b] -> [na, b]
      [na, _b] -> [na, b]
    end
  end

  def magnitude([a, b]) when is_integer(a) and is_integer(b) do
    3 * a + 2 * b
  end
  def magnitude([a, b]) do
    new_a = if is_integer(a), do: a, else: magnitude(a)
    new_b = if is_integer(b), do: b, else: magnitude(b)
    magnitude([new_a, new_b])
  end
end
