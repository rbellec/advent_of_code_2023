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

    location = ascii_string([?A..?Z], min: 1)

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

  # defmodule Part2 do
  # end
end

defmodule Mix.Tasks.Day08 do
  use Mix.Task

  def run(_) do
    input_filename = "inputs/day08.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(to_string(Day08.Part1.solve(input)))

    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(inspect(Day08.Part2.solve(directions)))
  end
end
