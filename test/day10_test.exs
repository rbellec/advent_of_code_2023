defmodule Day10Test do
  use ExUnit.Case

  setup do
    aoc_example_1 = """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """

    parsed_example_1 = %{
      :start => {1, 1},
      {1, 1} => "S",
      {1, 2} => "|",
      {1, 3} => "L",
      {2, 1} => "-",
      {2, 3} => "-",
      {3, 1} => "7",
      {3, 2} => "|",
      {3, 3} => "J",
      :max_x => 5,
      :max_y => 5
    }

    aoc_example_1_bis = """
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    """

    aoc_example_2 = """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """

    aoc_part2_exemple_1 = """
    ...........
    .S-------7.
    .|F-----7|.
    .||OOOOO||.
    .||OOOOO||.
    .|L-7OF-J|.
    .|II|O|II|.
    .L--JOL--J.
    .....O.....
    """

    expected_aoc_example_result = 0

    %{
      aoc_example_1: aoc_example_1,
      parsed_example_1: parsed_example_1,
      aoc_example_1_bis: aoc_example_1_bis,
      aoc_example_2: aoc_example_2,
      expected_aoc_example_result: expected_aoc_example_result,
      aoc_part2_exemple_1: aoc_part2_exemple_1
    }
  end

  describe "Parser" do
    test "parse simple graph", context do
      res = Day10.Parser.parse(context.aoc_example_1)
      assert(context.parsed_example_1 == res)
    end
  end

  describe "Graph" do
    test "format graph", context do
      parsed_graph = context.parsed_example_1

      assert(
        [east: {2, 1}, south: {1, 2}] ==
          Day10.Graph.node_connexions(parsed_graph, Map.get(parsed_graph, :start))
      )

      Day10.Graph.add_vertices(parsed_graph)
      # require IEx; IEx.pry()
    end

    test "Doing one step", context do
      graph = context.parsed_example_1
      start_node = Map.get(graph, :start)
      # res = Day10.Graph.step(graph, start_node, :south)
      assert({:west, {2, 1}} == Day10.Graph.step(graph, start_node, :south))
      # require IEx; IEx.pry()
    end

    test "Step to start node", context do
      graph = context.parsed_example_1
      # start_node = {1, 1}
      # res = Day10.Graph.step(graph, {2, 1}, :east)
      # require IEx; IEx.pry()
      assert({:east, {1, 1}} == Day10.Graph.step(graph, {2, 1}, :east))
    end

    test "Walk", context do
      graph = context.parsed_example_1
      start_node = Map.get(graph, :start)
      res = Day10.Graph.walk_from(graph, start_node)
      # require IEx; IEx.pry()

      assert(8 == Enum.count(res))
    end

    test "find letter matching pipe pattern" do
      letters = String.graphemes("|-LJ7F")

      letters
      |> Enum.each(fn letter ->
        assert(letter == Day10.Graph.find_letter_to_connect(Day10.Graph.open_pipes(letter)))
      end)
    end

    test "change start node", context do
      graph = Day10.Graph.transform_start_node(context.parsed_example_1)
      assert("F" == Map.get(graph, Day10.Graph.get_starting_node(graph)))
    end
  end

  describe "Part 1" do
    test "solve", context do
      assert(4 == Day10.Part1.solve(context.aoc_example_1))
      assert(4 == Day10.Part1.solve(context.aoc_example_1_bis))
      assert(8 == Day10.Part1.solve(context.aoc_example_2))
    end
  end

  describe "Part 2" do
    test "part 2", context do
      assert(4 == Day10.Part2.solve(context.aoc_part2_exemple_1))
    end
  end
end
