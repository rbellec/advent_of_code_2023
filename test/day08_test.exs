defmodule DayO8Test do
  use ExUnit.Case

  setup do
    demo_input_aoc_1 = """
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    """

    demo_input_aoc_2 = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """

    expected_example_1_result = 2
    expected_example_2_result = 6

    demo_part2_input_aoc = """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """

    expected_part_2_result = 6

    direction_line = "AAA = (BBB, BBB)"
    expected_parsed_line = [%{location: "AAA", left: "BBB", right: "BBB"}]

    %{
      direction_line: direction_line,
      expected_parsed_line: expected_parsed_line,
      demo_input_aoc_1: demo_input_aoc_1,
      demo_input_aoc_2: demo_input_aoc_2,
      expected_example_1_result: expected_example_1_result,
      expected_example_2_result: expected_example_2_result,
      demo_part2_input_aoc: demo_part2_input_aoc,
      expected_part_2_result: expected_part_2_result
    }
  end

  describe "Parsing directions" do
    import Day08.Parser

    test "parse", context do
      # res = direction(context.direction_line)
      # require IEx; IEx.pry()
      assert(elem(direction(context.direction_line), 1) == context.expected_parsed_line)
    end
  end

  describe "Part 1" do
    test "solve", context do
      # res = Day08.Part1.solve(context.demo_input_aoc_2)
      # require IEx; IEx.pry()
      assert(Day08.Part1.solve(context.demo_input_aoc_1) == context.expected_example_1_result)
      assert(Day08.Part1.solve(context.demo_input_aoc_2) == context.expected_example_2_result)
    end
  end

  describe "Part 2" do
    test "solve", context do
      res = Day08.Part2.solve(context.demo_part2_input_aoc)
      assert(res == context.expected_part_2_result)
    end
  end
end
