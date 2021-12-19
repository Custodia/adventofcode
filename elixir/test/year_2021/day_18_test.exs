defmodule AdventOfCode.Year2021.Day18Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Year2021

  test "part1" do
    assert Year2021.Day18.part1 == 3494
  end

  test "part2" do
    assert Year2021.Day18.part2 == 4712
  end

  test "sum_snail_sums" do
    snail_sums = Enum.map(1..6, fn i -> [i, i] end)
    result = [[[[5,0],[7,4]],[5,5]],[6,6]]
    assert Year2021.Day18.sum_snail_sums(snail_sums) == result

    snail_sums = [
      [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]],
      [7,[[[3,7],[4,3]],[[6,3],[8,8]]]],
      [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]],
      [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]],
      [7,[5,[[3,8],[1,4]]]],
      [[2,[2,2]],[8,[8,1]]],
      [2,9],
      [1,[[[9,3],9],[[9,0],[0,7]]]],
      [[[5,[7,4]],7],1],
      [[[[4,2],2],6],[8,7]]
    ]
    result = [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]
    assert Year2021.Day18.sum_snail_sums(snail_sums) == result
  end

  test "reduce" do
    snail_sum = [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
    result = [[[[0,7],4],[[7,8],[6,0]]],[8,1]]
    assert Year2021.Day18.reduce(snail_sum) == result
  end

  test "snail_sum" do
    assert Year2021.Day18.snail_sum([1,2], [[3,4],5]) == [[1,2],[[3,4],5]]
  end

  test "explode" do
    values = [
      [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]],
      [[[[0,7],4],[7,[[8,4],9]]],[1,1]],
      [[[[0,7],4],[15,[0,13]]],[1,1]],
      [[[[0,7],4],[15,[0,13]]],[1,1]]
    ]

    assert Year2021.Day18.explode(Enum.at(values, 0)) == Enum.at(values, 1)
    assert Year2021.Day18.explode(Enum.at(values, 1)) == Enum.at(values, 2)
    assert Year2021.Day18.explode(Enum.at(values, 2)) == Enum.at(values, 3)
    assert Year2021.Day18.explode(Enum.at(values, 3)) == Enum.at(values, 3)
  end

  describe "split" do
    test "with integer" do
      Enum.each(0..9, fn n ->
        assert Year2021.Day18.split(n) == n
      end)

      assert Year2021.Day18.split(10) == [5, 5]
      assert Year2021.Day18.split(11) == [5, 6]
      assert Year2021.Day18.split(12) == [6, 6]
    end

    test "with snail number when there are no elements to split" do
      values = [
        [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]],
        [[[[0,7],4],[7,[[8,4],9]]],[1,1]],
        [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]],
        [[[[0,7],4],[[7,8],[6,0]]],[8,1]]
      ]

      Enum.each(values, fn snail_number ->
        assert Year2021.Day18.split(snail_number) == snail_number
      end)
    end

    test "with snail number when there are elements to split" do
      values = [
        [[[[0,7],4],[15,[0,13]]],[1,1]],
        [[[[0,7],4],[[7,8],[0,13]]],[1,1]],
        [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]
      ]

      assert Year2021.Day18.split(Enum.at(values, 0)) == Enum.at(values, 1)
      assert Year2021.Day18.split(Enum.at(values, 1)) == Enum.at(values, 2)
    end
  end

  test "magnitude" do
    values = [
      { [[1,2],[[3,4],5]], 143 },
      { [[[[0,7],4],[[7,8],[6,0]]],[8,1]], 1384 },
      { [[[[1,1],[2,2]],[3,3]],[4,4]], 445 },
      { [[[[3,0],[5,3]],[4,4]],[5,5]], 791 },
      { [[[[5,0],[7,4]],[5,5]],[6,6]], 1137 },
      { [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]], 3488 }
    ]

    Enum.each(values, fn {snail_number, result} ->
      assert Year2021.Day18.magnitude(snail_number) == result
    end)
  end
end
