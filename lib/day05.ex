# Define a function from a place to the next in the garden.
defmodule Day05.GardenFunction do
  defstruct [:from, :to, :offset, :length, :source, :destination]
end

defmodule Day05.Parser do
  import NimbleParsec

  def to_garden_function_element(list) do
    # TODO
    Enum.map(& &1)
  end

  spaces = times(string(" "), min: 1)
  eol = choice([string("\r\n"), string("\n")])
  sep = ignore(choice([spaces, eol]) |> times(min: 1))

  colon = string(":")
  number = ignore(spaces) |> integer(min: 1)

  seeds = ignore(string("seeds:")) |> concat(times(number, min: 1) |> tag(:seeds))

  # Garden places not needed in part 1 at least
  location_names = spaces |> concat(ascii_string([?a..?z, ?-, ?\s], min: 1)) |> concat(colon)

  range_definition =
    integer(min: 1)
    |> unwrap_and_tag(:destination)
    |> (concat(number) |> unwrap_and_tag(:source))
    |> (concat(number) |> unwrap_and_tag(:length))

  garden_function =
    ignore(location_names)
    |> concat(times(sep |> range_definition |> wrap, min: 1) |> map(:to_garden_function_element))

  file =
    seeds
    |> concat(times(sep |> garden_function |> wrap, min: 1))
    |> eos

  # line =
  #   ignore(string("Card"))
  #   |> (concat(number) |> unwrap_and_tag(:index))
  #   |> ignore(colon)
  #   |> concat(times(number, min: 1) |> tag(:winnings))
  #   |> ignore(pipe_sep)
  #   |> concat(times(number, min: 1) |> tag(:your_draw))
  #   |> ignore(optional(eol))

  # Ok

  defparsec(:seeds, seeds)
  defparsec(:location_names, garden_distance)
  defparsec(:range_definition, range_definition)
  defparsec(:garden_function, garden_function)
  defparsec(:file, file)
end

defmodule Day04.Part1 do


  # def solve(input) do
  #   input
  #   |> Day05.Parser.()
  # end
end

defmodule Mix.Tasks.Day05 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    input_filename = "inputs/day05.txt"
    {:ok, input} = File.read(input_filename)

    # IO.puts("--- Part 1 ---")
    # IO.puts(Day05.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day05.Part2.solve(input))
  end
end
