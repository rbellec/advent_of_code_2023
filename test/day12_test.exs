defmodule Day12Test do
  use ExUnit.Case

  setup do
    aoc_example_1 = """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """

    line_example = ".??..??...?##. 1,1,3"

    %{
      aoc_example_1: aoc_example_1,
      line_example: line_example
    }
  end

  # describe "Parser" do
  #   test "parse line", context do
  #     res = Day12.Parser.parse_line({context.line_example, 0})
  #     assert(context.parsed_example_1 == res)
  #   end
  # end

  describe "Part1" do
    import Day12.Part1

    test "count all possible positions of a group in a substring", _context do
      # example_line = String.graphemes("????.######..#####.")

      assert(possible_placements_from_position(String.graphemes("#"), 1) == [1])
      assert(possible_placements_from_position(String.graphemes("##"), 1) == [2, 1])

      assert(possible_placements_from_position(String.graphemes("###"), 1) == [3, 2, 1])

      assert(possible_placements_from_position(String.graphemes("##.##"), 1) == [4, 3, 2, 2, 1])

      assert(possible_placements_from_position(String.graphemes("#"), 2) == [0])
      assert(possible_placements_from_position(String.graphemes("##"), 2) == [1, 0])

      assert(possible_placements_from_position(String.graphemes("###"), 2) == [2, 1, 0])

      assert(
        possible_placements_from_position(String.graphemes("##.##"), 2) ==
          [
            2,
            1,
            1,
            1,
            0
          ]
      )

      # assert(Day12.Part1.possible_placements_from_position(String.graphemes("#"), 1) == [1])
      # assert(Day12.Part1.possible_placements_from_position(String.graphemes("#"), 1) == [1])

      # assert(9 == Day12.Part1.possible_positions(substring, 3) |> Enum.count())
      # assert(6 == Day12.Part1.possible_positions(substring, 4) |> Enum.count())
    end

    test "get number of possibilities per group size per position matrix", _context do
      springs = String.graphemes("???.###")
      groups = [1, 1, 3]
      possibility_per_group_size_matrix(springs, groups)
      # require IEx; IEx.pry()
    end
  end
end
