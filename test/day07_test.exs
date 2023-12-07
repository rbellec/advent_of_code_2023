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
        bet: 765,
        cards: [13, 10, 3, 3, 2],
        hand_value: 2,
        hand_name: :pairs
      },
      %Day07.Hand{
        text_hand: "T55J5",
        bet: 684,
        cards: [11, 10, 5, 5, 5],
        hand_value: 4,
        hand_name: :brelan
      },
      %Day07.Hand{
        text_hand: "KK677",
        bet: 28,
        cards: [13, 13, 7, 7, 6],
        hand_value: 3,
        hand_name: :two_pairs
      },
      %Day07.Hand{
        text_hand: "KTJJT",
        bet: 220,
        cards: ~c"\r\v\v\n\n",
        hand_value: 3,
        hand_name: :two_pairs
      },
      %Day07.Hand{
        text_hand: "QQQJA",
        bet: 483,
        cards: [14, 12, 12, 12, 11],
        hand_value: 4,
        hand_name: :brelan
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
