defmodule AdventOfCode.Year2018.Day04 do
  @filename "../2018/inputs/day04.txt"

  @shift_begin_regex ~r/Guard #(\d+) begins shift/
  @asleep_regex ~r/\[\d{4}-\d{2}-\d{2} \d{2}:(\d{2})\] falls asleep/
  @wakes_up_regex ~r/\[\d{4}-\d{2}-\d{2} \d{2}:(\d{2})\] wakes up/

  def part1 do
    File.stream!(@filename)
    |> parse_input()
    |> Enum.max_by(fn {_guard_id, minutes} ->
      Enum.reduce(minutes, 0, fn {_minute, count}, acc -> acc + count end)
    end)
    |> get_guard_score()
  end

  def part2 do
    File.stream!(@filename)
    |> parse_input()
    |> Enum.max_by(fn {_guard_id, minutes} ->
      Enum.max_by(minutes, &elem(&1, 1)) |> elem(1)
    end)
    |> get_guard_score()
  end

  def parse_input(input_stream) do
    input_stream
    |> Stream.map(&String.trim/1)
    |> Enum.sort()
    |> Enum.reduce({[], []}, fn line, {chunk, result} ->
      beginning_of_shift? = String.match?(line, @shift_begin_regex)
      case {beginning_of_shift?, chunk} do
        {true, []} -> {[line], result}
        {true, chunk} -> {[line], [Enum.reverse(chunk) | result]}
        {false, chunk} -> {[line | chunk], result}
      end
    end)
    |> then(fn {chunk, result} -> Enum.reverse([Enum.reverse(chunk) | result]) end)
    |> Enum.map(&parse_shift/1)
    |> Enum.reduce(%{}, fn {guard_id, minutes}, minutes_map ->
      add_minutes_to_guard(guard_id, minutes, minutes_map)
    end)
  end

  def parse_shift([ shift_begin_line | other_lines ]) do
    {parse_guard_id(shift_begin_line), parse_sleeping_minutes(other_lines)}
  end

  def parse_guard_id(line) do
    Regex.run(@shift_begin_regex, line, capture: :all_but_first)
    |> then(fn [guard_id] -> String.to_integer(guard_id) end)
  end

  def parse_sleeping_minutes(lines, result \\ [])
  def parse_sleeping_minutes([], result), do: Enum.reverse(result)
  def parse_sleeping_minutes([asleep_line, wakes_up_line | tail], result) do
    [start_minute] = Regex.run(@asleep_regex, asleep_line, capture: :all_but_first) |> Enum.map(&String.to_integer/1)
    [end_minute] = Regex.run(@wakes_up_regex, wakes_up_line, capture: :all_but_first) |> Enum.map(&String.to_integer/1)
    parse_sleeping_minutes(tail, [{start_minute, end_minute} | result])
  end

  def add_minutes_to_guard(guard_id, minutes, minutes_map) do
    minutes
    |> Enum.reduce(minutes_map, fn {start_minute, end_minute}, minutes_map ->
      start_minute..end_minute-1
      |> Enum.reduce(minutes_map, fn minute, minutes_map ->
        Map.update(minutes_map, guard_id, %{}, fn guard_map ->
          Map.update(guard_map, minute, 1, &(&1 + 1))
        end)
      end)
    end)
  end

  def get_guard_score({guard_id, minutes}) do
    top_minute =
      minutes
      |> Enum.max_by(&elem(&1, 1))
      |> elem(0)

    guard_id * top_minute
  end
end
