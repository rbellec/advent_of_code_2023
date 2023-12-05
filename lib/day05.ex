# Define a function from a place to the next in the garden.
defmodule Day05.GardenFunctionElement do

  defstruct [:from, :to, :offset, :length, :source, :destination]

  def convert_range(raw_range) do
    length = raw_range |> Keyword.get(:length)
    source = raw_range |> Keyword.get(:source)
    destination = raw_range |> Keyword.get(:destination)
    offset = destination - source

    %Day05.GardenFunctionElement{
      offset: offset,
      length: length,
      source: source,
      destination: destination
    }
  end
end

defmodule Day05.Parser do
  import NimbleParsec

  spaces = times(string(" "), min: 1)
  eol = choice([string("\r\n"), string("\n")])
  sep = ignore(choice([spaces, eol]) |> times(min: 1))

  colon = string(":")
  number = ignore(spaces) |> integer(min: 1)

  seeds = ignore(string("seeds:")) |> concat(times(number, min: 1) |> tag(:seeds))

  # Garden places not needed in part 1 at least
  misc_string = ascii_string([?a..?z, ?A..?Z, ?\-, ?\s], min: 1)
  location_names = misc_string |> concat(colon)

  range_definition =
    integer(min: 1)
    |> unwrap_and_tag(:destination)
    |> concat(number |> unwrap_and_tag(:source))
    |> concat(number |> unwrap_and_tag(:length))

  garden_function =
    ignore(location_names)
    |> concat(
      times(sep |> concat(range_definition) |> wrap, min: 1)
      |> map({Day05.GardenFunctionElement, :convert_range, []})
    )

  file =
    seeds
    |> concat(times(sep |> concat(garden_function) |> wrap, min: 1))
    # |> eos

  defparsec(:seeds, seeds)
  defparsec(:misc_string, misc_string)
  defparsec(:location_names, location_names)
  defparsec(:range_definition, range_definition)
  defparsec(:garden_function, garden_function)
  defparsec(:file, file)
end

defmodule Day05.Part1 do
  # def solve(input) do
  #   input
  #   |> Day05.Parser.()
  # end
end

defmodule Mix.Tasks.Day05 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    # input_filename = "inputs/day05.txt"
    # {:ok, input} = File.read(input_filename)

    # IO.puts("--- Part 1 ---")
    # IO.puts(Day05.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day05.Part2.solve(input))
  end
end
