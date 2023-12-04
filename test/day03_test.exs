defmodule DayO3Test do
  import Day03.Part1
  import Day03.Parser
  use ExUnit.Case

  setup do
    input_line = "467..+.114.."

    demo_input_aoc = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    # See https://www.reddit.com/r/adventofcode/comments/189q9wv/2023_day_3_another_sample_grid_to_use/
    # symbols at
    # [{9, 0}, {0, 1}, {7, 2}, {2, 4}, {11, 6}, {6, 7}, {1, 10}, {11, 10}, {8, 11}]
    # values : Part 1: 925, Part 2: 6756
    reddit_alternate_grid = """
    12.......*..
    +.........34
    .......-12..
    ..78........
    ..*....60...
    78.........9
    .5.....23..$
    8...90*12...
    ............
    2.2......12.
    .*.........*
    1.1..503+.56
    """

    %{
      input_line: input_line,
      demo_input_aoc: demo_input_aoc,
      reddit_alternate_grid: reddit_alternate_grid
    }
  end

  describe "Day 03 parsing" do
    test "Parse a line", context do
      expected = [
        %Day03.Match{
          type: :number,
          string: "467",
          coord: {0, 0},
          int_value: 467,
          length: 3,
          positions: [{0, 0}, {1, 0}, {2, 0}]
        },
        %Day03.Match{
          type: :number,
          string: "114",
          coord: {7, 0},
          int_value: 114,
          length: 3,
          positions: [{7, 0}, {8, 0}, {9, 0}]
        },
        %Day03.Match{
          type: :symbol,
          string: "+",
          coord: {5, 0},
          int_value: nil,
          length: 1,
          positions: [{5, 0}]
        }
      ]

      assert(expected == parse_line(context[:input_line], 0))
    end
  end

  describe "Day 03 part 1" do
    test "Find symbol positions", context do
      {line_tokens, _} = parse_input(context[:input_line])
      assert([{5, 0}] = Day03.Part1.get_symbol_positions(line_tokens))

      assert(
        [{3, 1}, {6, 3}, {3, 4}, {5, 5}, {3, 8}, {5, 8}] =
          parse_input(context[:demo_input_aoc])
          |> elem(0)
          |> Day03.Part1.get_symbol_positions()
      )

      assert(
        [{9, 0}, {0, 1}, {7, 2}, {2, 4}, {11, 6}, {6, 7}, {1, 10}, {11, 10}, {8, 11}] =
          parse_input(context[:reddit_alternate_grid])
          |> elem(0)
          |> Day03.Part1.get_symbol_positions()
      )
    end

    test "find around positions" do
      assert(
        [{0, 0}, {1, 0}, {2, 0}, {0, 1}, {2, 1}, {0, 2}, {1, 2}, {2, 2}] ==
          Day03.Part1.around({1, 1})
      )
    end

    test "get number arounds a position, simple case", context do
      map_2d = parse_input(context[:reddit_alternate_grid]) |> elem(1)
      assert([23, 90, 12] == get_numbers_around_position(map_2d, {6, 7}))
    end

    test "get number arounds a position, same numbers have multiple 'around positions'",
         context do
      map_2d = parse_input(context[:demo_input_aoc]) |> elem(1)
      assert([467, 35] == get_numbers_around_position(map_2d, {3, 1}))
    end

    test "demo values", context do
      assert(4361 == solve(context[:demo_input_aoc]))
      assert(925 == solve(context[:reddit_alternate_grid]))
    end
  end

  describe "Day 03 Part 2" do
    test "find gear and other symbols positions", context do
      tokens = parse_input(context[:reddit_alternate_grid]) |> elem(0)
      symbols = Day03.Part1.get_symbol_positions(tokens)
      gears = Day03.Part2.gear_positions(tokens)
      assert([{9, 0}, {2, 4}, {6, 7}, {1, 10}, {11, 10}] == gears)
      assert([{0, 1}, {7, 2}, {11, 6}, {8, 11}] == symbols -- gears)
    end

    test "handle gears", context do
      {_, map_2d} = parse_input(context[:reddit_alternate_grid])

      assert(0 == Day03.Part2.handle_gear({9, 0}, map_2d))
      assert(78 * 78 == Day03.Part2.handle_gear({2, 4}, map_2d))
      assert(0 == Day03.Part2.handle_gear({6, 7}, map_2d))
      assert(0 == Day03.Part2.handle_gear({1, 10}, map_2d))
      assert(12 * 56 == Day03.Part2.handle_gear({11, 10}, map_2d))
    end

    test "Solve part 2", context do
      assert(467_835 == Day03.Part2.solve(context[:demo_input_aoc]))
      assert(6756 == Day03.Part2.solve(context[:reddit_alternate_grid]))
    end
  end
end
