defmodule AdventOfCode.Year2018.Day03 do
  @filename "../2018/inputs/day03.txt"

  @line_regex ~r/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/

  def part1 do
    File.stream!(@filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line -> Regex.run(@line_regex, line, capture: :all_but_first) end)
    |> Stream.map(&Enum.map(&1, fn e -> String.to_integer(e) end))
    |> Enum.reduce(%{}, &add_claim_to_map(&2, &1))
    |> Enum.filter(fn {_coord, count} -> count > 1 end)
    |> Enum.count()
  end

  def part2 do
    claims =
      File.stream!(@filename)
      |> Stream.map(&String.trim/1)
      |> Enum.map(fn line -> Regex.run(@line_regex, line, capture: :all_but_first) end)
      |> Stream.map(&Enum.map(&1, fn e -> String.to_integer(e) end))

    claim_map = Enum.reduce(claims, %{}, &add_claim_to_map(&2, &1))

    claims
    |> Enum.find(fn claim -> claim_has_no_conflicts?(claim, claim_map) end)
    |> then(fn [i | _] -> i end)
  end

  def get_claim_coordinates([_i, x, y, xz, yz]) do
    for xi <- x..x+xz-1, yi <- y..y+yz-1, do: {xi, yi}
  end

  def add_claim_to_map(map, claim) do
    claim
    |> get_claim_coordinates()
    |> Enum.reduce(map, fn coord, acc -> Map.update(acc, coord, 1, &(&1 + 1)) end)
  end


  def claim_has_no_conflicts?(claim, claim_map) do
    claim
    |> get_claim_coordinates()
    |> Enum.all?(&(Map.get(claim_map, &1) == 1))
  end
end
