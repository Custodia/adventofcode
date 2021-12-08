defmodule AdventOfCode.Year2021.Day04 do
  @filename "../inputs/2021/day04.txt"

  def part1 do
    {numbers, boards} = parse_input()

    {number, first_winner} = get_winner(numbers, boards)

    first_winner
    |> Enum.concat()
    |> Enum.filter(fn e -> e != :match end)
    |> Enum.sum()
    |> then(&(&1 * number))
  end

  def part2 do
    {numbers, boards} = parse_input()

    {number, loser} = get_loser(numbers, boards)

    loser
    |> Enum.concat()
    |> Enum.filter(fn e -> e != :match end)
    |> Enum.sum()
    |> then(&(&1 * number))
  end

  def get_winner([number | remaining_numbers], boards) do
    new_boards =
      Enum.map(boards, &Enum.map(&1, fn row ->
        Enum.map(row, fn e -> if e == number, do: :match, else: e end)
      end))

    case Enum.find(new_boards, &board_is_winner/1) do
      nil -> get_winner(remaining_numbers, new_boards)
      first_winner -> {number, first_winner}
    end
  end

  def get_loser([number | remaining_numbers], boards) do
    new_boards =
      Enum.map(boards, &Enum.map(&1, fn row ->
          Enum.map(row, fn e -> if e == number, do: :match, else: e end)
      end))

    case Enum.reject(new_boards, &board_is_winner/1) do
      [] -> {number, List.first(new_boards)}
      filtered_boards -> get_loser(remaining_numbers, filtered_boards)
    end
  end

  def board_is_winner(board) do
    transposed_board = transpose(board)

    Enum.any?(board, &Enum.all?(&1, fn e -> e == :match end)) ||
      Enum.any?(transposed_board, &Enum.all?(&1, fn e -> e == :match end))
  end

  def transpose(rows) do
    rows
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  def parse_input do
    [[numbers] | boards] =
      File.stream!(@filename)
      |> Stream.map(&String.trim/1)
      |> Stream.chunk_by(fn e -> e == "" end)
      |> Stream.filter(fn e -> e != [""] end)
      |> Stream.map(&Enum.map(&1, fn e ->
        String.split(e, ~r/( +|,)/)
        |> Enum.map(fn s -> String.to_integer(s) end)
      end))
      |> Enum.into([])

    {numbers, boards}
  end
end
