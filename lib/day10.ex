# I will use this problem to try libgraph, hence a more detailed representation of graph.

defmodule Day10 do
  defmodule Parser do
    import Enum

    # @graph_chars String.graphemes("|-LJ7FS")

    def parse(input) do
      lines =
        input
        |> String.split("\n", trim: true)

      graph =
        lines
        |> with_index()
        |> reduce(%{}, fn {line, y}, graph_elements ->
          line
          |> String.graphemes()
          |> with_index()
          |> reduce(graph_elements, fn
            {"S", x}, graph_elements_c ->
              graph_elements_c
              |> Map.put({x, y}, "S")
              |> Map.put(:start, {x, y})

            {letter, x}, graph_elements_c
            when letter in ["|", "-", "L", "J", "7", "F"] ->
              Map.put(graph_elements_c, {x, y}, letter)

            _, graph_elements_c ->
              graph_elements_c
          end)
        end)

      graph
      |> Map.put(:max_y, Enum.count(lines))
      |> Map.put(:max_x, lines |> hd |> String.length())
    end
  end

  defmodule Graph do
    import Enum

    def get_starting_node(graph) do
      Map.get(graph, :start)
    end

    def open_pipes(letter) do
      case letter do
        "S" -> [:north, :east, :south, :west]
        "|" -> [:north, :south]
        "-" -> [:east, :west]
        "7" -> [:south, :west]
        "J" -> [:north, :west]
        "F" -> [:east, :south]
        "L" -> [:north, :east]
        _ -> []
      end
    end

    # Returns all connecting nodes around the one in parameter.
    # [{:north, {x, y-1}}, ...]
    def node_connexions(graph, coords) do
      letter = Map.get(graph, coords)

      open_pipes(letter)
      |> map(&{&1, coord_of_direction(coords, &1)})
      |> filter(&connects?(graph, elem(&1, 1), opposite(elem(&1, 0))))
    end

    def coord_of_direction({x, y}, direction) do
      case direction do
        :north -> {x, y - 1}
        :south -> {x, y + 1}
        :east -> {x + 1, y}
        :west -> {x - 1, y}
      end
    end

    @spec opposite(:east | :north | :south | :west) :: :east | :north | :south | :west
    def opposite(direction) do
      case direction do
        :north -> :south
        :south -> :north
        :east -> :west
        :west -> :east
      end
    end

    # Ask if this cell can be connected to the incoming direction. If cell is not in the graph, nil is handled properly.
    @spec connects?(map(), any(), :east | :north | :south | :west) :: boolean()
    def connects?(graph, coords, incoming_direction) do
      letter = Map.get(graph, coords)

      case incoming_direction do
        :north -> letter in ["J", "L", "|", "S"]
        :south -> letter in ["F", "7", "|", "S"]
        :east -> letter in ["F", "L", "-", "S"]
        :west -> letter in ["J", "7", "-", "S"]
      end
    end

    # return a graph (Map) with a :vertices key holding a list of... vertices !
    #
    def add_vertices(graph) do
      vertices =
        graph
        |> flat_map(fn {coords, _} ->
          node_connexions(graph, coords)
          |> map(&{coords, elem(&1, 1)})
        end)

      Map.put(graph, :vertices, MapSet.new(vertices))
    end

    # Build the path of node from the first with a direction.
    # No optim on testing already visited not yet, will do if needed.
    def walk_from(graph, starting_coords) do
      # Start by the first available direction in the passed node.
      # Won't work on isolated nodes
      first_direction =
        node_connexions(graph, starting_coords)
        |> hd
        |> elem(0)

      starting_path = [{first_direction, starting_coords}]
      walk(graph, starting_path, MapSet.new([starting_coords]))
    end

    def walk(graph, walked_path, visited) do
      {incoming_direction, current_coords} = hd(walked_path)

      next_node = step(graph, current_coords, incoming_direction)
      {_, next_coords} = next_node

      cond do
        MapSet.member?(visited, next_coords) ->
          walked_path

        true ->
          walk(graph, [next_node | walked_path], MapSet.put(visited, next_coords))
      end
    end

    # What is the next step from this node. Note : in part 1 nodes can have only one. I won't protect here from tangling pipes.
    def step(graph, current_coords, incoming_direction) do
      {outgoing_direction, next_coords} =
        node_connexions(graph, current_coords)
        |> filter(&(elem(&1, 0) != incoming_direction))
        |> hd

      {opposite(outgoing_direction), next_coords}
    end

    def find_letter_to_connect(opened_pipes) do
      opened_pipes
      |> Enum.sort()
      |> case do
        [:north, :south] -> "|"
        [:east, :west] -> "-"
        [:south, :west] -> "7"
        [:north, :west] -> "J"
        [:east, :south] -> "F"
        [:east, :north] -> "L"
      end
    end

    # I need to be able to treat start node as a letter node for part 2 (and would have been interesting for part 1)
    def transform_start_node(graph) do
      start_coords = get_starting_node(graph)

      letter =
        node_connexions(graph, start_coords)
        |> Enum.map(&elem(&1, 0))
        |> find_letter_to_connect

      Map.put(graph, start_coords, letter)
    end
  end

  defmodule Part1 do
    # Return a graph with start node connected with the correct adjascent nodes
    # def connect_start(graph) do
    #   start = Map.get(graph, :start)
    # end

    def solve(input) do
      graph = Day10.Parser.parse(input)
      start_node = Map.get(graph, :start)

      path_length =
        Day10.Graph.walk_from(graph, start_node)
        |> Enum.count()

      Float.ceil(path_length / 2)
    end
  end

  defmodule Part2 do
    import Enum

    @pointing_north String.graphemes("|LJ")

    def solve(input) do
      graph =
        Day10.Parser.parse(input)
        |> Day10.Graph.transform_start_node()

      start_coords = Day10.Graph.get_starting_node(graph)

      path_nodes =
        Day10.Graph.walk_from(graph, start_coords)
        |> map(&elem(&1, 1))
        |> MapSet.new()

      lines_range = 0..(Map.get(graph, :max_y) - 1)

      flat_map(lines_range, &solve_line(graph, path_nodes, &1))
      |> Enum.count()
    end

    def inside_reducer(graph, path_nodes, current_coords, {is_inside, nodes_inside_loop}) do
      # IO.puts("#{inspect(current_coords)}, is inside: #{inspect(is_inside)}")
      cond do
        MapSet.member?(path_nodes, current_coords) ->
          if Map.get(graph, current_coords) in @pointing_north do
            {!is_inside, nodes_inside_loop}
          else
            {is_inside, nodes_inside_loop}
          end

        is_inside ->
          {is_inside, [current_coords | nodes_inside_loop]}

        true ->
          {is_inside, nodes_inside_loop}
      end
    end

    # Return coords of all nodes inside the loop.
    def solve_line(graph, path_nodes, y) do
      cols_range = 0..(Map.get(graph, :max_x) - 1)

      Enum.reduce(cols_range, {false, []}, &inside_reducer(graph, path_nodes, {&1, y}, &2))
      |> elem(1)
    end
  end
end

defmodule Mix.Tasks.Day10 do
  use Mix.Task

  def run(_) do
    input_filename = "inputs/day10.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(to_string(Day10.Part1.solve(input)))

    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(to_string(Day10.Part2.solve(input)))
  end
end
