defmodule DayO4Test do
  use ExUnit.Case

  setup do
    input_line = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"

    demo_input_aoc = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

    # For part 2
    state_list = [
      %{index: 1, copies: 10, score: 2},
      %{index: 2, copies: 1, score: 1},
      %{index: 3, copies: 1, score: 0},
      %{index: 4, copies: 1, score: 0}
    ]

    state = state_list |> Enum.into(%{}, &{&1.index, &1})

    %{
      input_line: input_line,
      demo_input_aoc: demo_input_aoc,
      state_list: state_list,
      state: state
    }
  end

  describe "Day 04 parsing" do
    test "Parse a line", context do
      expected = [
        index: 1,
        winnings: [41, 48, 83, 86, 17],
        your_draw: [83, 86, 6, 31, 17, 9, 48, 53]
      ]

      assert(expected == elem(Day04.Parser.line(context[:input_line]), 1))
    end

    test "parse line with space before first int", _context do
      test_line = "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1"

      expected = [
        index: 3,
        winnings: [1, 21, 53, 59, 44],
        your_draw: [69, 82, 63, 72, 16, 21, 14, 1]
      ]

      assert(expected == elem(Day04.Parser.line(test_line), 1))
    end

    test "parse demo data", context do
      expected = [
        %{
          index: 1,
          winnings: [41, 48, 83, 86, 17],
          your_draw: [83, 86, 6, 31, 17, 9, 48, 53]
        },
        %{
          index: 2,
          winnings: [13, 32, 20, 16, 61],
          your_draw: [61, 30, 68, 82, 17, 32, 24, 19]
        },
        %{
          index: 3,
          winnings: [1, 21, 53, 59, 44],
          your_draw: [69, 82, 63, 72, 16, 21, 14, 1]
        },
        %{index: 4, winnings: [41, 92, 73, 84, 69], your_draw: [59, 84, 76, 51, 58, 5, 54, 83]},
        %{
          index: 5,
          winnings: [87, 83, 26, 28, 32],
          your_draw: [88, 30, 70, 12, 93, 22, 82, 36]
        },
        %{
          index: 6,
          winnings: [31, 18, 13, 56, 72],
          your_draw: [74, 77, 10, 23, 35, 67, 36, 11]
        }
      ]

      assert(expected == elem(Day04.Parser.game(context[:demo_input_aoc]), 1))
    end
  end

  describe "Day 04 solving" do
    import Day04.Part1

    test "number_won_per_games", context do
      scores = [4, 2, 2, 1, 0, 0]

      results =
        Day04.Parser.game(context[:demo_input_aoc])
        |> elem(1)
        |> Enum.map(&score_game/1)
        |> Enum.map(& &1.score)

      assert(scores == results)
    end

    test "solve part 1 demo", context do
      assert(13 == Day04.Part1.solve(context[:demo_input_aoc]))
    end
  end

  describe "Part 2" do
    # Day04.Parser.game(demo_input_aoc) |> elem(1) |> Enum.map(&Day04.Part1.score_game/1)
    @tag timeout: 300_000
    test "apply game 1 to a state", context do
      expected =
        [
          %{index: 1, copies: 10, score: 2},
          %{index: 2, copies: 11, score: 1},
          %{index: 3, copies: 11, score: 0},
          %{index: 4, copies: 1, score: 0}
        ]
        |> Enum.into(%{}, &{&1.index, &1})

      game_1 = hd(context.state_list)
      assert(expected == Day04.Part2.apply_game(game_1, context.state))
    end

    test "apply_game to all games in demo", context do
      expected_copies = [1, 2, 4, 8, 14, 1]
      result = Day04.Part2.calculate_copies(context.demo_input_aoc)

      # require IEx; IEx.pry
      assert(expected_copies == result)
    end
  end
end
