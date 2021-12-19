defmodule AdventOfCode.Year2021.Day17 do
  @filename "../inputs/2021/day17.txt"

  @target_area_regex ~r/x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/

  def part1 do
    {{_, _}, {_, y2}} = File.read!(@filename) |> parse_input()
    Enum.sum(1..abs(y2 + 1))
  end

  def part2 do
    target_area = File.read!(@filename) |> parse_input()
    {{_, tx2}, {_, ty2}} = target_area
    coords = for x <- 1..tx2, y <- ty2..abs(ty2 + 1), do: {x, y}
    coords
    |> Stream.map(fn coord ->
      case get_trajectory(coord, target_area) do
        {:hit, _} -> true
        {:miss, _} -> false
      end
    end)
    |> Enum.filter(&(&1 == true))
    |> Enum.count()
  end

  def parse_input(input) do
    [x1, x2, y2, y1] =
      Regex.run(@target_area_regex, input, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    {{x1, x2}, {y1, y2}}
  end

  def get_trajectory(iv, {{tx1, tx2}, {ty1, ty2}}) when tx1 > tx2 or ty1 < ty2 do
    get_trajectory(
      iv,
      {{min(tx1, tx2), max(tx1, tx2)}, {max(ty1, ty2), min(ty1, ty2)}}
    )
  end
  def get_trajectory(initial_velocity, target = {{_, tx2}, {_, ty2}}) do
    Stream.iterate(initial_velocity, fn {vx, vy} -> {max(vx - 1, 0), vy - 1} end)
    |> Enum.reduce_while({{0, 0}, []}, fn {vx, vy}, {{px, py}, coords} ->
      {x, y} = {px + vx, py + vy}
      new_coords = [ {x, y} | coords ]
      cond do
        x > tx2 || y < ty2 ->
          {:halt, {:miss, Enum.reverse(new_coords)}}
        coord_within_target?({x, y}, target) ->
          {:halt, {:hit, Enum.reverse(new_coords)}}
        true ->
          {:cont, {{x, y}, new_coords}}
      end
    end)
  end

  def coord_within_target?({x, y}, {{tx1, tx2}, {ty1, ty2}}) do
    x >= tx1 && x <= tx2 && y <= ty1 && y >= ty2
  end
end
