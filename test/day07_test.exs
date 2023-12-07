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

    expected_bets_order = [765, 220, 28, 684, 483]
    expected_part_1_result = 6440

    expected_parse_result = [
      %Day07.Hand{
        text_hand: "32T3K",
        cards: [13, 10, 3, 3, 2],
        bet: 765,
        hand_value: 2,
        hand_name: :pair,
        hand_composition: [3, 13, 10, 2]
      },
      %Day07.Hand{
        text_hand: "T55J5",
        cards: [11, 10, 5, 5, 5],
        bet: 684,
        hand_value: 4,
        hand_name: :brelan,
        hand_composition: [5, 11, 10]
      },
      %Day07.Hand{
        text_hand: "KK677",
        cards: [13, 13, 7, 7, 6],
        bet: 28,
        hand_value: 3,
        hand_name: :two_pairs,
        hand_composition: [13, 7, 6]
      },
      %Day07.Hand{
        text_hand: "KTJJT",
        cards: [13, 11, 11, 10, 10],
        bet: 220,
        hand_value: 3,
        hand_name: :two_pairs,
        hand_composition: [11, 10, 13]
      },
      %Day07.Hand{
        text_hand: "QQQJA",
        cards: [14, 12, 12, 12, 11],
        bet: 483,
        hand_value: 4,
        hand_name: :brelan,
        hand_composition: [12, 14, 11]
      }
    ]

    %{
      expected_parse_result: expected_parse_result,
      expected_part_1_result: expected_part_1_result,
      expected_bets_order: expected_bets_order,
      demo_input_aoc: demo_input_aoc
    }
  end

  describe "Parsing hands" do
    import Day07.Parser

    test "parse", context do
      res = parse(context.demo_input_aoc)
      # require IEx; IEx.pry()
      assert(parse(context.demo_input_aoc) == context.expected_parse_result)
    end
  end

  describe "Part 1" do
    test "compare and sort hands", context do
      sorted_bets =
        Enum.sort(context.expected_parse_result, &Day07.Hand.compare_hands/2)
        |> Enum.map(& &1.bet)

      assert(sorted_bet = context.expected_bets_order)
    end

    test "solve", context do
      result = Day07.Part1.solve(context.demo_input_aoc)
      # require IEx; IEx.pry()
      assert(result = context.expected_part_1_result)
    end
  end
end
