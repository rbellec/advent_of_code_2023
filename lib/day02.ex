defmodule Day02.GameParser do
  import NimbleParsec
  # Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green

  space = string(" ")
  # eol = choice([string("\r\n"), string("\n")])
  comma = string(", ")
  semicolon = string(", ")

  red = string("red") |> replace(:red)
  green = string("green") |> replace(:green)
  blue = string("blue") |> replace(:blue)

  # color = choice([red, green, blue]) |> unwrap_and_tag(:color)
  color = choice([red, green, blue])
  color_draw = integer(min: 1) |> ignore(space) |> concat(color) |> ignore(optional(comma))
  single_draw = times(color_draw, min: 1) |> ignore(optional(semicolon))

  defparsec(:color, color)
  defparsec(:color_draw, color_draw, debug: false)
  defparsec(:single_draw, single_draw)
end

defmodule Day02.Part1 do
  # import Pathex; import Pathex.Lenses
  def solve(input) do
    input
  end
end

defmodule Day02.Part2 do
end

defmodule Mix.Tasks.Day02 do
  use Mix.Task

  def run(_) do
    demo_data = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    # {:ok, input} = File.read("inputs/demo-input.txt")

    # input_filename = "inputs/day02.txt"
    # {:ok, input} = File.read(input_filename)
    input = demo_data

    IO.puts("--- Part 1 ---")
    IO.puts(Day02.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day02.Part2.solve(input))
  end
end
