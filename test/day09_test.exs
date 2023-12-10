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
      # If you want to check a case that does looks like a monome a.x^n
      # res = Day09.Part1.all_derivations([0,0,0,0,0,0,1,2,3,2,1,0,0,0,0,0,0,0,0,0,0,0])
      # require IEx; IEx.pry()
      assert(all_derivations == [[0, 0, 0, 0], [3, 3, 3, 3, 3], [0, 3, 6, 9, 12, 15]])
    end

    test "integration tests", _context do
      assert([1, 1, 1] == Day09.Part1.rebuild(1, [0, 0, 0]))
      assert([6, 8, 11] == Day09.Part1.rebuild(5, [1, 2, 3]))
      # require IEx; IEx.pry()
    end

    test "solve one line", context do
      res = Day09.Part1.solve_line(context.nombres_impairs)
      # require IEx; IEx.pry()
      assert([0, 3, 6, 9, 12, 15, 18] == res)
    end

    test "solve", context do
      res = Day09.Part1.solve(context.aoc_example)
      assert(114 == res)
      # require IEx; IEx.pry()
    end
  end

  describe "Part 2" do
    test "part 2", context do
      res = Day09.Part2.solve(context.aoc_example)
      # require IEx; IEx.pry()
      assert(2 == res)
    end
  end
end
