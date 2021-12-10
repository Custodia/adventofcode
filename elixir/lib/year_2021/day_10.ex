defmodule AdventOfCode.Year2021.Day10 do
  @filename "../inputs/2021/day10.txt"

  @syntax_error_scores %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  @autocomplete_scores %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }


  def part1 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&get_first_illegal_character/1)
    |> Stream.filter(&is_binary/1)
    |> Stream.map(&Map.fetch!(@syntax_error_scores, &1))
    |> Enum.sum()
  end

  def part2 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&get_first_illegal_character/1)
    |> Stream.filter(&is_list/1)
    |> Stream.map(&Enum.reduce(&1, 0, fn c, acc ->
      acc * 5 + Map.fetch!(@autocomplete_scores, c)
    end))
    |> Enum.sort()
    |> then(&Enum.at(&1, div(length(&1), 2)))

  end

  def get_first_illegal_character(line) do
    Enum.reduce_while(line, [], fn c, acc ->
      case {c, acc} do
        {")", [ "(" | tail ]} -> {:cont, tail}
        {"]", [ "[" | tail ]} -> {:cont, tail}
        {"}", [ "{" | tail ]} -> {:cont, tail}
        {">", [ "<" | tail ]} -> {:cont, tail}

        {")", _} -> {:halt, c}
        {"]", _} -> {:halt, c}
        {"}", _} -> {:halt, c}
        {">", _} -> {:halt, c}

        {c, _} -> {:cont, [ c | acc ]}
      end
    end)
  end
end
