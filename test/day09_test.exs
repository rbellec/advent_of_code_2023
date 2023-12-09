defmodule DayO9Test do
  use ExUnit.Case

  setup do
    aoc_example = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

    nombres_impairs = [0, 3, 6, 9, 12, 15]

    expected_aoc_example_result = 2

    %{
      aoc_example: aoc_example,
      nombres_impairs: nombres_impairs,
      expected_aoc_example_result: expected_aoc_example_result
    }
  end

  describe "Part 1" do

    test "discrete derivation", context do
      lists = Day09.Parser.parse(context.aoc_example)
      res = Day09.Part1.discrete_derivative(hd(lists))
      # require IEx; IEx.pry()
      assert(res == [3, 3, 3, 3, 3])
    end

    test "all_derivations of a simple list", context do
      all_derivations = Day09.Part1.all_derivations(context.nombres_impairs)
      # res = Day09.Part1.all_derivations([0,0,0,0,0,0,1,2,3,2,1,0,0,0,0,0,0,0,0,0,0,0])
      # require IEx; IEx.pry()
      assert(all_derivations == [[0, 0, 0, 0], [3, 3, 3, 3, 3], [0, 3, 6, 9, 12, 15]])
    end

    test "integration", _context do
      zs = Day09.Part1.zero_stream
      assert (Day09.Part1.next_element_in(zs) == 0)
      int_1 = Day09.Part1.integrale_stream(5, zs)
      assert (Day09.Part1.next_element_in(int_1) == 5)
      int_2 = Day09.Part1.integrale_stream(2, int_1)
      assert([2, 7, 12, 17, 22] == int_2 |> Enum.take(5))
      # require IEx; IEx.pry()
    end

    test "solve one line", context do
      res = Day09.Part1.solved_line(context.nombres_impairs)
      # require IEx; IEx.pry()
      assert([0, 3, 6, 9, 12, 15, 18] == res)
      assert( 18 == Day09.Part1.solve_line(context.nombres_impairs))
    end

    # test "solve", context do
      # require IEx; IEx.pry()
      # assert(Day09.Part1.solve(context.aoc_example) == context.expected_aoc_example_result)
    # end
  end
end
