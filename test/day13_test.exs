defmodule Day13Test do
  use ExUnit.Case
  import Enum
  import Day13

  setup do
    aoc_example_1 = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """

    %{
      aoc_example_1: aoc_example_1
    }
  end

  # test "parse", context do
  #   Day13.parse(context.aoc_example_1)
  #   require IEx; IEx.pry()
  # end
  describe "Part 1" do
    test ~c"Find \"one line reflexions\", which is the first detection", context do
      mirror_fields = parse(context.aoc_example_1)
      transposed_mirror_files = Enum.map(mirror_fields, &transpose/1)

      assert([[2], [3]] == map(mirror_fields, &find_successive_identic_lines(&1, 0)))
      assert([[4], [2, 6]] == map(transposed_mirror_files, &find_successive_identic_lines(&1, 0)))
    end

    # Check we detect reflection in the second mirror field between lines 4 and 5 (1 indexed)
    test "check reflexion", context do
      field2 = at(parse(context.aoc_example_1), 1)
      # Works for lines 4 and 5
      assert(check_reflexion(field2, 0, 3))

      # and not for any other
      assert(!check_reflexion(field2, 0, 0))
      assert(!check_reflexion(field2, 0, 1))
      assert(!check_reflexion(field2, 0, 2))
      assert(!check_reflexion(field2, 0, 4))
      assert(!check_reflexion(field2, 0, 5))
    end

    test "find reflexions", context do
      mirror_fields = parse(context.aoc_example_1)
      transposed_mirror_files = Enum.map(mirror_fields, &transpose/1)

      assert([3] == Day13.find_reflexions(at(mirror_fields, 1), 0))
      assert([4] == Day13.find_reflexions(at(transposed_mirror_files, 0), 0))
    end

    test "Solve", context do
      assert(405 == solve(context.aoc_example_1, 1))
      # require IEx
      # IEx.pry()
    end

    # test "Solve", context do
    #   assert(405 == solve(context.aoc_example_1, 1))
    #   # require IEx
    #   # IEx.pry()
    # end

    # test "part 2", context do
    #   l1 = "..##..##."
    #   l2 = "#.##..##."
    #   # no time to work on part 2 now
    # end
  end

  describe "Part 2" do
    # test "find reflexions", context do
    #   mirror_fields = parse(context.aoc_example_1)
    #   transposed_mirror_files = Enum.map(mirror_fields, &transpose/1)

    #   assert([3] == Day13.find_reflexions(at(mirror_fields, 1), 1))
    #   assert([4] == Day13.find_reflexions(at(transposed_mirror_files, 0), 1))
    # end

    test "Solve", context do
      assert(400 == solve(context.aoc_example_1, 2))
      # require IEx
      # IEx.pry()
    end
  end
end
