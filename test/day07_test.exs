defmodule DayO7Test do
  use ExUnit.Case

  setup do
    demo_input_aoc = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    # https://www.reddit.com/r/adventofcode/comments/18cr4xr/2023_day_7_better_example_input_not_a_spoiler/
    # Part 1: 6592
    # Part 2: 6839
    redit_other_input = """
    2345A 1
    Q2KJJ 13
    Q2Q2Q 19
    T3T3J 17
    T3Q33 11
    2345J 3
    J345A 2
    32T3K 5
    T55J5 29
    KK677 7
    KTJJT 34
    QQQJA 31
    JJJJJ 37
    JAAAA 43
    AAAAJ 59
    AAAAA 61
    2AAAA 23
    2JJJJ 53
    JJJJ2 41
    """

    own_test_case = """
    2345J 3
    2345A 1
    """

    expected_bets_order = [765, 220, 28, 684, 483]
    expected_part_1_result = 6440

    expected_parse_result = [
      %Day07.Hand{
        text_hand: "32T3K",
        cards: ["3", "2", "T", "3", "K"],
        bet: 765,
        hand_value: 2,
        hand_name: :pair,
        hand_composition: ["3", "T", "K", "2"]
      },
      %Day07.Hand{
        text_hand: "T55J5",
        cards: ["T", "5", "5", "J", "5"],
        bet: 684,
        hand_value: 4,
        hand_name: :brelan,
        hand_composition: ["5", "T", "J"]
      },
      %Day07.Hand{
        text_hand: "KK677",
        cards: ["K", "K", "6", "7", "7"],
        bet: 28,
        hand_value: 3,
        hand_name: :two_pairs,
        hand_composition: ["K", "7", "6"]
      },
      %Day07.Hand{
        text_hand: "KTJJT",
        cards: ["K", "T", "J", "J", "T"],
        bet: 220,
        hand_value: 3,
        hand_name: :two_pairs,
        hand_composition: ["T", "J", "K"]
      },
      %Day07.Hand{
        text_hand: "QQQJA",
        cards: ["Q", "Q", "Q", "J", "A"],
        bet: 483,
        hand_value: 4,
        hand_name: :brelan,
        hand_composition: ["Q", "J", "A"]
      }
    ]

    %{
      expected_parse_result: expected_parse_result,
      expected_part_1_result: expected_part_1_result,
      expected_bets_order: expected_bets_order,
      redit_other_input: redit_other_input,
      demo_input_aoc: demo_input_aoc
    }
  end

  describe "Parsing hands" do
    import Day07.Parser

    test "parse", context do
      res = parse(context.demo_input_aoc)
      # require IEx; IEx.pry()
      # assert(parse(context.demo_input_aoc) == context.expected_parse_result)
    end
  end

  describe "Part 1" do
    test "compare and sort hands", context do
      sorted_bets =
        Enum.sort(context.expected_parse_result, &Day07.Hand.compare_hands/2)
        |> Enum.map(& &1.bet)

      assert(sorted_bet = context.expected_bets_order)
    end

    test "test redit example", context do
      # Day07.Part1.print_order(context.own_test_case)
      # Day07.Part1.print_order("2345J 3\n2345A 1\n")
      Day07.Part1.print_order(context.redit_other_input)
      result = Day07.Part1.solve(context.redit_other_input)
      # # require IEx; IEx.pry()
      assert(result == 6592)
    end

    test "solve", context do
      # Day07.Part1.print_order(context.demo_input_aoc)
      result = Day07.Part1.solve(context.demo_input_aoc)
      # require IEx; IEx.pry()
      assert(result = context.expected_part_1_result)
    end
  end
end
