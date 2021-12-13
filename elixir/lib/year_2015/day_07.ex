defmodule AdventOfCode.Year2015.Day07 do
  use Bitwise
  @filename "../inputs/2015/day07.txt"

  @max_integer List.duplicate(1, 16) |> Integer.undigits(2)

  def part1 do
    File.stream!(@filename)
    |> parse_input()
    |> solve_circuit()
    |> Map.fetch!("a")
  end

  def part2 do
    input = File.stream!(@filename) |> parse_input()

    %{"a" => first_a} = solve_circuit(input)
    input
    |> Enum.map(fn e -> if elem(e, 1) == "b", do: {["#{first_a}"], "b"}, else: e end)
    |> solve_circuit()
    |> Map.fetch!("a")
  end

  def parse_input(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " -> "))
    |> Enum.map(fn [cmd_string, to] -> {String.split(cmd_string, " "), to} end)
  end

  def solve_circuit(commands, signal_map \\ %{})
  def solve_circuit([], signal_map), do: signal_map
  def solve_circuit(commands, signal_map) do
    {new_commands, new_signal_map} =
      commands
      |> Enum.reduce({[], signal_map}, fn command, {commands, signal_map} ->
        case run_command(command, signal_map) do
          {:ok, updated_signal_map} -> {commands, updated_signal_map}
          :error -> {[command | commands], signal_map}
        end
      end)

    if length(commands) == length(new_commands) do
      {new_commands, new_signal_map}
    else
      solve_circuit(new_commands, new_signal_map)
    end
  end

  def run_command({[from], to}, signal_map) do
    case {Integer.parse(from), Map.fetch(signal_map, from)} do
      {{int, ""}, _} -> {:ok, Map.put(signal_map, to, int)}
      {_, {:ok, v}} -> {:ok, Map.put(signal_map, to, v)}
      _ -> :error
    end
  end

  def run_command({["NOT", from], to}, signal_map) do
    case Map.fetch(signal_map, from) do
      {:ok, v} -> {:ok, Map.put(signal_map, to, bxor(v, @max_integer))}
      :error -> :error
    end
  end

  def run_command({["1", "AND", right], to}, signal_map) do
    case Map.fetch(signal_map, right) do
      {:ok, right} -> {:ok, Map.put(signal_map, to, 1 &&& right)}
      _ -> :error
    end
  end
  def run_command({[left, "AND", right], to}, signal_map) do
    case {Map.fetch(signal_map, left), Map.fetch(signal_map, right)} do
      {{:ok, left}, {:ok, right}} -> {:ok, Map.put(signal_map, to, left &&& right)}
      _ -> :error
    end
  end

  def run_command({[left, "OR", right], to}, signal_map) do
    case {Map.fetch(signal_map, left), Map.fetch(signal_map, right)} do
      {{:ok, left}, {:ok, right}} -> {:ok, Map.put(signal_map, to, left ||| right)}
      _ -> :error
    end
  end

  def run_command({[left, "LSHIFT", int], to}, signal_map) do
    case {Map.fetch(signal_map, left), String.to_integer(int)} do
      {{:ok, left}, right} -> {:ok, Map.put(signal_map, to, left <<< right)}
      _ -> :error
    end
  end

  def run_command({[left, "RSHIFT", int], to}, signal_map) do
    case {Map.fetch(signal_map, left), String.to_integer(int)} do
      {{:ok, left}, right} -> {:ok, Map.put(signal_map, to, left >>> right)}
      _ -> :error
    end
  end
end
