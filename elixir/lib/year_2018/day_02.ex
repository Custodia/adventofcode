defmodule AdventOfCode.Year2018.Day02 do
  @filename "../inputs/2018/day02.txt"

  def part1 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&Enum.frequencies/1)
    |> Enum.reduce({0, 0}, fn frequencies, {twos, threes} ->
      has_twos? = Enum.any?(frequencies, fn {_, c} -> c == 2 end)
      has_threes? = Enum.any?(frequencies, fn {_, c} -> c == 3 end)
      twos = if has_twos?, do: twos + 1, else: twos
      threes = if has_threes?, do: threes + 1, else: threes
      {twos, threes}
    end)
    |> then(fn {twos, threes} -> twos * threes end)
  end

  def part2 do
    lines = File.stream!(@filename) |> Enum.map(&String.trim/1)

    lines
    |> Stream.with_index(1)
    |> Stream.flat_map(fn {a, index} ->
      lines
      |> Enum.drop(index)
      |> Enum.map(fn b -> {a, b} end)
    end)
    |> Enum.find(fn {a, b} -> is_off_by_one?(a, b) end)
    |> then(fn {a, b} -> get_matching_parts(a, b) end)
  end

  def is_off_by_one?(a, b, offset \\ 0)
  def is_off_by_one?("", "", 1), do: true
  def is_off_by_one?("", "", _), do: false
  def is_off_by_one?(<<c::binary-size(1)>> <> rest1, <<c::binary-size(1)>> <> rest2, offset), do:
    is_off_by_one?(rest1, rest2, offset)
  def is_off_by_one?(<<_::binary-size(1)>> <> rest1, <<_::binary-size(1)>> <> rest2, 0), do:
    is_off_by_one?(rest1, rest2, 1)
  def is_off_by_one?(_, _, _), do: false

  def get_matching_parts(a, b, m \\ "")
  def get_matching_parts("", "", m), do: m
  def get_matching_parts(<<c::binary-size(1)>> <> rest1, <<c::binary-size(1)>> <> rest2, m), do:
    get_matching_parts(rest1, rest2, m <> c)
  def get_matching_parts(<<_::binary-size(1)>> <> rest1, <<_::binary-size(1)>> <> rest2, m), do:
    get_matching_parts(rest1, rest2, m)
end
