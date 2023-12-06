# Define a function from a place to the next in the garden.
# This name is a proof I should be doing AoC in the morning and not at night !
defmodule Day05.GardenFunctionElement do
  defstruct [:from, :to, :offset, :length, :source, :destination, :input_range, :image_range]

  # def garden_func(range, offset) do
  #   def garden_func()
  # end

  def garden_func(0, _, _) do
    nil
  end

  def garden_func(length, source, destination) do
    offset = destination - source

    %Day05.GardenFunctionElement{
      offset: offset,
      length: length,
      source: source,
      destination: destination,
      input_range: Range.new(source, source + length - 1),
      image_range: Range.new(destination, destination + length - 1)
    }
  end

  def convert_range(raw_range) do
    length = raw_range |> Keyword.get(:length)
    source = raw_range |> Keyword.get(:source)
    destination = raw_range |> Keyword.get(:destination)

    garden_func(length, source, destination)
  end

  # Take an integer and apply the function.
  # return nil if its
  def apply_one(function_elem, location) do
    case location in function_elem.input_range do
      true -> location + function_elem.offset
      false -> nil
    end
  end

  def apply_garden_fun(list_of_elements, location) do
    list_of_elements
    |> Enum.map(&apply_one(&1, location))
    # return current location if no movement was available
    |> Enum.reject(&is_nil/1)
    |> case do
      [] -> [location]
      new_locations -> new_locations
    end
  end

  def apply_garden_fun_to_locations(list_of_elements, locations) do
    Enum.flat_map(locations, &apply_garden_fun(list_of_elements, &1))
  end

  # Return tuple with an (optional) result GardenFunctionElement and a list of remainders.
  # {result, [remainders]}
  # composition in usual order.
  # def compose(dest, src) do
  #   dest_r = dest.input_range
  #   src_r = src.image_range

  #   cond
  #     Range.disjoint?(src_r, dest_r) -> {nil, [src, dest]}
  #     src_r.first <= dest_r.first && src_r.last >= dest_r.last ->
  #       # dest range included in source
  #       # |----- src ------------|
  #       #     |----- dest ------|
  #       {garden_func(dest.length, dest.source - src.offset, dest.destination),
  #       [garden_func(dest_r.first - src_r.first, src.source, src.destination),
  #       garden_func(dest_r.first - src_r.first, src.source, src.destination)]}
  #     src_r.first <= dest_r.first && src_r.last < dest_r.last ->
  #       # |----- src -----|
  #       #       |----- dest ------|
  #       {garden_func(src_r.last - dest_r.first + 1, dest.source - src.offset, dest.destination),
  #       [garden_func(dest_r.first - src_r.first, src.source, src.destination),
  #       garden_func(dest_r.last - src_r.last, dest.source - src.offset, dest.destination)]

  #     # From here
  #     src_r.first > dest_r.first && src_r.last <= dest_r.last ->
  #       # source range included in dest
  #       #    |----- src ----|
  #       # |-------- dest ---------|
  #       {garden_func(src.length, src.source, src.destination + dest.offset),
  #         [garden_func(src_r.last - dest_r.first, src.source, src.destination + dest.offset),
  #         ] }
  #       src_r.first > dest_r.first && src_r.last < dest_r.last ->
  #       #         |----- src -----|
  #       # |----- dest ------|
  #       [ create_fun_elem(dest_r.last - src_r.first + 1, src.source, src.source + src.offset + dest.offset) ]
  #     end
  #   end
  # end
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
    |> concat(times(sep |> concat(garden_function) |> wrap, min: 1) |> tag(:functions))

  # |> eos

  defparsec(:seeds, seeds)
  defparsec(:misc_string, misc_string)
  defparsec(:location_names, location_names)
  defparsec(:range_definition, range_definition)
  defparsec(:garden_function, garden_function)
  defparsec(:file, file)
end

defmodule Day05.Part1 do
  # My first idea was to compose each non deterministic "function" and get a list of final functions representing the seed-to-location function
  # But I did not find any working range arithmetic in elixir and I do not have time to write it.
  def solve(input) do
    data = Day05.Parser.file(input) |> elem(1)

    seeds = Keyword.get(data, :seeds)
    functions = Keyword.get(data, :functions)

    final_locations(functions, seeds)
    |> Enum.min()
  end

  def final_locations(functions, seeds) do
    Enum.reduce(functions, seeds, &Day05.GardenFunctionElement.apply_garden_fun_to_locations/2)
  end
end

defmodule Day05.Part2 do
  # Composing functions with range arithmetic seems the proper way to go, but...
  # Not enough time. Let's try brute force !
  def solve(input) do
    data = Day05.Parser.file(input) |> elem(1)

    seeds = Keyword.get(data, :seeds)
    functions = Keyword.get(data, :functions)

    all_seeds =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.flat_map(fn [start, length] ->
        Range.new(start, start + length - 1)
        |> Enum.to_list()
      end)

    # require IEx; IEx.pry

    Day05.Part1.final_locations(functions, all_seeds)
    |> Enum.min()
  end
end

defmodule Mix.Tasks.Day05 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    input_filename = "inputs/day05.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(Day05.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day05.Part2.solve(input))
  end
end
