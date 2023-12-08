defmodule Day08 do
  defmodule Parser do
    import NimbleParsec
    # sep is either a space, (, ), = or comma.
    char_sep = ascii_string([?\s, ?\(, ?\), ?\,, ?=], min: 1)
    eol = choice([string("\r\n"), string("\n")])

    sep = times(choice([char_sep, eol]), min: 1)

    left = string("L") |> replace(:left)
    right = string("R") |> replace(:right)

    instructions = times(choice([left, right]), min: 1) |> tag(:instructions)

    location = ascii_string([?A..?Z, ?0..?9], min: 1)

    direction =
      location
      |> unwrap_and_tag(:location)
      |> ignore(sep)
      |> concat(location |> unwrap_and_tag(:left))
      |> ignore(sep)
      |> concat(location |> unwrap_and_tag(:right))
      |> ignore(sep)
      |> wrap
      |> map({Map, :new, []})

    direction_file =
      instructions
      |> ignore(sep)
      |> concat(times(direction, min: 1) |> tag(:directions))
      |> eos
      |> wrap
      |> map({Map, :new, []})

    defparsec(:direction, direction)
    defparsec(:parse_directions, direction_file)
  end

  defmodule Part1 do
    def solve(input) do
      directions_definitions = Parser.parse_directions(input) |> elem(1) |> hd

      directions_map =
        directions_definitions.directions
        |> Enum.into(%{}, &{&1.location, &1})

      starting_location = "AAA"
      final_location = "ZZZ"

      Stream.cycle(directions_definitions.instructions)
      |> Stream.with_index(1)
      |> Enum.reduce_while(
        {nil, starting_location},
        fn {step_direction, step}, {_, current_location} ->
          next_location =
            directions_map |> Map.get(current_location) |> Map.get(step_direction)

          # require IEx; IEx.pry()
          case next_location do
            # I could return only current_step + 1, but I have a superstition in modifying the
            # invariant in the last step
            ^final_location -> {:halt, {step, final_location}}
            next_location -> {:cont, {step, next_location}}
          end
        end
      )
      |> elem(0)
    end
  end

  defmodule Part2 do
    def is_starting_location?(location) do
      String.at(location, 2) == "A"
    end

    def is_ending_location?(location) do
      String.at(location, 2) == "Z"
    end

    # Because `termination_condition` is such a boring name
    def are_we_there_yet?(location_list) do
      Enum.all?(location_list, &is_ending_location?/1)
    end

    def next_location(directions_map, step_direction, current_location) do
      directions_map |> Map.get(current_location) |> Map.get(step_direction)
    end

    def next_locations(directions_map, step_direction, current_locations) do
      Enum.map(current_locations, &next_location(directions_map, step_direction, &1))
    end

    def solve_brute_force(input) do
      directions_definitions = Parser.parse_directions(input) |> elem(1) |> hd

      directions_map =
        directions_definitions.directions
        |> Enum.into(%{}, &{&1.location, &1})

      starting_locations = directions_map |> Map.keys() |> Enum.filter(&is_starting_location?/1)

      # Seems it could be a good fit for Stream.transform
      Stream.cycle(directions_definitions.instructions)
      |> Stream.with_index(1)
      |> Enum.reduce_while(
        {nil, starting_locations},
        fn {step_direction, step_index}, {_, current_locations} ->
          # require IEx; IEx.pry()
          next_locations =
            next_locations(directions_map, step_direction, current_locations) |> Enum.uniq()

          next_acc = {step_index, next_locations}

          if are_we_there_yet?(next_locations) do
            {:halt, next_acc}
          else
            {:cont, next_acc}
          end
        end
      )
      |> elem(0)
    end
  end
end

defmodule Mix.Tasks.Day08 do
  use Mix.Task

  def run(_) do
    input_filename = "inputs/day08.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(to_string(Day08.Part1.solve(input)))

    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(to_string(Day08.Part2.solve_brute_force(input)))
  end
end
