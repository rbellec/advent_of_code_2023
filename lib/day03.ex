defmodule Day03.Match do
  # Coord marks the position of the first letter of the match
  defstruct [:type, :string, :coord, :int_value, :length, positions: []]
end

defmodule Day03.Parser do
  import Pathex
  import Pathex.Lenses

  def parse_input(input) do
    tokens =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index(fn line, line_index ->
        parse_line(line, line_index)
      end)
      |> List.flatten()

    map_2d =
      tokens
      |> Enum.flat_map(fn token ->
        token.positions |> Enum.map(fn position -> {position, token} end)
      end)
      |> Enum.into(%{})

    {tokens, map_2d}
  end

  # Note : symbols seems to be anything that is not a number or a dot
  def parse_line(line, line_index) do
    parse_type(line, line_index, ~r/\d+/, :number) ++
      parse_type(line, line_index, ~r/[^\d\.]/, :symbol)
  end

  def parse_type(line, line_index, regexp, type) do
    matches_str = Regex.scan(regexp, line)
    positions = Regex.scan(regexp, line, return: :index)

    Enum.zip(matches_str, positions)
    |> Enum.map(fn {string_l, position_l} ->
      # require IEx; IEx.pry
      text = hd(string_l)
      position = hd(position_l)

      int_value =
        case type do
          :number -> String.to_integer(text)
          _ -> nil
        end

      x = elem(position, 0)
      length = elem(position, 1)
      ends_at = x + length - 1

      %Day03.Match{
        type: type,
        string: text,
        coord: {x, line_index},
        int_value: int_value,
        length: length,
        positions: Enum.map(x..ends_at, fn pos -> {pos, line_index} end)
      }
    end)
  end
end

defmodule Day03.Part1 do
  import Pathex
  import Pathex.Lenses

  import Day03.Parser

  def solve(input) do
    {token_list, map_2d} = parse_input(input)

    get_symbol_positions(token_list)
    |> Enum.flat_map(&get_numbers_around_position(map_2d, &1))
    |> Enum.sum()
  end

  # All position around a given position
  def around({x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  def get_numbers_around_position(map_2d, position) do
    around(position)
    |> Enum.map(&Map.get(map_2d, &1))
    |> view(star() ~> matching(%{type: :number}))
    |> case do
      {:ok, numbers} -> Enum.uniq_by(numbers, & &1.coord) |> Enum.map(& &1.int_value)
      :error -> []
    end
  end

  def get_symbol_positions(token_list) do
    token_list
    |> view!(star() ~> matching(%{type: :symbol}) ~> path(:positions))
    |> List.flatten()
  end
end

defmodule Day03.Part2 do
  import Pathex
  import Pathex.Lenses
  import Day03.Part1
  import Day03.Parser

  def solve(input) do
    {token_list, map_2d} = parse_input(input)

    gear_positions(token_list)
    |> Enum.map(&handle_gear(&1, map_2d))
    |> Enum.sum()
  end

  def handle_gear(position, map_2d) do
    Day03.Part1.around(position)
    |> Enum.map(&Map.get(map_2d, &1))
    |> view(star() ~> matching(%{type: :number}))
    |> case do
      {:ok, numbers} ->
        Enum.uniq_by(numbers, & &1.coord)
        # Only consider gears with 2 numbers around
        |> case do
          [a, b] -> a.int_value * b.int_value
          _ -> 0
        end

      :error ->
        0
    end
  end

  def gear_positions(token_list) do
    token_list
    |> view!(star() ~> matching(%{type: :symbol, string: "*"}) ~> path(:positions))
    |> List.flatten()
  end
end

defmodule Mix.Tasks.Day03 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    input_filename = "inputs/day03.txt"
    # input_filename = "inputs/demo-input.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(Day03.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day03.Part2.solve(input))
  end
end
