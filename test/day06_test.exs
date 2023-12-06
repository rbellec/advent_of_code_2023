defmodule DayO5Test do
  use ExUnit.Case

  setup do
    demo_input_aoc = """
    Time:      7  15   30
    Distance:  9  40  200
    """

    expected_parse_result = [{7, 9}, {15, 40}, {30, 200}]

    %{
      expected_parse_result: expected_parse_result,
      demo_input_aoc: demo_input_aoc
    }
  end

  describe "Day 06 parsing" do
    import Day06.Parser

    test "parse", context do
      assert(parse(context.demo_input_aoc) == context.expected_parse_result)
    end
  end

  describe "Part 1" do
    import Day06.Part1

    test "solve one race", _context do
      assert(4 == solve_race({7, 9}))
      assert(8 == solve_race({15, 40}))
      assert(9 == solve_race({30, 200}))
    end

    test "Solve part 1", context do
      assert(288 == solve(context.demo_input_aoc))
    end
  end
end
