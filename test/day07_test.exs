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
    import Day07.Part1
  end
end
