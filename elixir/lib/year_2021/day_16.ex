defmodule AdventOfCode.Year2021.Day16.ValuePacket do
  @enforce_keys [:version, :type_id, :value]
  defstruct [:version, :type_id, :value]
end

defmodule AdventOfCode.Year2021.Day16.OperatorPacket do
  @enforce_keys [:version, :type_id, :children]
  defstruct [:version, :type_id, :children, :length_type_id]
end

defmodule AdventOfCode.Year2021.Day16 do
  alias AdventOfCode.Year2021.Day16.ValuePacket
  alias AdventOfCode.Year2021.Day16.OperatorPacket

  @filename "../inputs/2021/day16.txt"

  def part1 do
    File.read!(@filename)
    |> parse_packet()
    |> flatten_packet()
    |> Enum.reduce(0, fn packet, acc -> acc + packet.version end)
  end

  def part2 do
    File.read!(@filename)
    |> parse_packet()
    |> get_packet_value()
  end

  def parse_input(input) do
    string = input |> String.trim()

    string
    |> String.to_integer(16)
    |> Integer.to_string(2)
    |> String.pad_leading(String.length(string) * 4, "0")
  end

  def get_packet_value(packet) do
    case packet do
      %ValuePacket{value: value} -> value
      %OperatorPacket{type_id: 0, children: children} ->
        children
        |> Enum.map(&get_packet_value/1)
        |> Enum.sum()
      %OperatorPacket{type_id: 1, children: children} ->
        children
        |> Enum.map(&get_packet_value/1)
        |> Enum.product()
      %OperatorPacket{type_id: 2, children: children} ->
        children
        |> Enum.map(&get_packet_value/1)
        |> Enum.min()
      %OperatorPacket{type_id: 3, children: children} ->
        children
        |> Enum.map(&get_packet_value/1)
        |> Enum.max()
      %OperatorPacket{type_id: 5, children: [child_1, child_2]} ->
        if get_packet_value(child_1) > get_packet_value(child_2), do: 1, else: 0
      %OperatorPacket{type_id: 6, children: [child_1, child_2]} ->
        if get_packet_value(child_1) < get_packet_value(child_2), do: 1, else: 0
      %OperatorPacket{type_id: 7, children: [child_1, child_2]} ->
        if get_packet_value(child_1) == get_packet_value(child_2), do: 1, else: 0
    end
  end

  def parse_packet(string) do
    {packet, _rest} = string |> parse_input() |> parse_sub_packet()

    packet
  end

  def parse_sub_packet(<<version::binary-size(3)>> <> "100" <> rest) do
    {value, rest} = parse_literal_value(rest)

    value_packet = %ValuePacket{
      version: String.to_integer(version, 2),
      type_id: String.to_integer("100", 2),
      value: String.to_integer(value, 2)
    }
    {value_packet, rest}
  end
  def parse_sub_packet(string) do
    <<version::binary-size(3)>> <> rest = string
    <<type_id::binary-size(3)>> <> rest = rest
    {length_type_id, length, rest} = parse_sub_packet_length(rest)

    {children, rest} = case length do
      {:length, length} ->
        target_length = String.length(rest) - length

        Stream.repeatedly(fn -> nil end)
        |> Enum.reduce_while({[], rest}, fn nil, {children, rest} ->
          {result, rest} = parse_sub_packet(rest)
          if String.length(rest) == target_length do
            {:halt, {Enum.reverse([ result | children]), rest}}
          else
            {:cont, {[ result | children ], rest}}
          end
        end)
      {:sub_packets, count} ->
        1..count
        |> Enum.reduce({[], rest}, fn _, {children, rest} ->
          {result, rest} = parse_sub_packet(rest)
          {[result | children], rest}
        end)
        |> then(fn {children, rest} -> {Enum.reverse(children), rest} end)
    end

    operator = %OperatorPacket{
      version: String.to_integer(version, 2),
      type_id: String.to_integer(type_id, 2),
      length_type_id: length_type_id,
      children: children
    }
    {operator, rest}
  end

  def parse_sub_packet_length("0" <> <<length::binary-size(15)>> <> rest) do
    {"0", {:length, String.to_integer(length, 2)}, rest}
  end
  def parse_sub_packet_length("1" <> <<length::binary-size(11)>> <> rest) do
    {"1", {:sub_packets, String.to_integer(length, 2)}, rest}
  end

  def parse_literal_value("1" <> <<value::binary-size(4)>> <> rest) do
    {following_values, rest} = parse_literal_value(rest)
    {value <> following_values, rest}
  end
  def parse_literal_value("0" <> <<value::binary-size(4)>> <> rest), do:
    {value, rest}

  def flatten_packet(packet) do
    case packet do
      %{children: children} ->
        [packet | Enum.flat_map(children, &flatten_packet/1) ]
      %{} ->
        [packet]
    end
  end
end
