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

    expected_part_1_result = 2
    expected_part_2_result = 6

    direction_line = "AAA = (BBB, BBB)"
    expected_parsed_line = [%{location: "AAA", left: "BBB", right: "BBB"}]

    %{
      direction_line: direction_line,
      expected_parsed_line: expected_parsed_line,
      demo_input_aoc_1: demo_input_aoc_1,
      demo_input_aoc_2: demo_input_aoc_2,
      expected_part_1_result: expected_part_1_result,
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

    # test "parse file", context do
    #   data_1 = parse_directions(context.demo_input_aoc_1)
    #   data_2 = parse_directions(context.demo_input_aoc_2)
    #   require IEx;      IEx.pry()

    # end
  end

  describe "Part 1" do
    test "solve", context do
      # res = Day08.Part1.solve(context.demo_input_aoc_2)
      # require IEx; IEx.pry()
      assert(Day08.Part1.solve(context.demo_input_aoc_1) == context.expected_part_1_result)
      assert(Day08.Part1.solve(context.demo_input_aoc_2) == context.expected_part_2_result)
    end
  end

  # describe "Part 2" do
  #   test "with AoC example", context do
  #     # Day07.Part2.print_order(context.redit_other_input)
  #     assert(Day07.Part2.solve(context.demo_input_aoc_1) == )
  #   end
  # end
end
