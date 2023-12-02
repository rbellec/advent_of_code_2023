defmodule Day02.GameParser do
  import NimbleParsec

  # Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green

  # sp = ignore(ascii_char(" "))
  # eol = choice([string("\r\n"), string("\n")])
  # color_draw_sep = ascii_char(",")


  red = string("red")
  green = string("green")
  blue = string("blue")

  color = choice([red, green, blue]) |> unwrap_and_tag(:color)

  defparsec :color, color

  # defparsec :color_draw, integer |> space |> color, debug: true
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
    demo_data= """
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
