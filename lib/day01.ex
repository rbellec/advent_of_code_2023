defmodule Day01.Part1 do
  import Pathex
  import Pathex.Lenses
  @moduledoc """
  Documentation for `Day01.Part1`.
  """

  def solve(input) do
    input
    |> parse_input()
    |> Enum.map(&line_value/1)
    |> Enum.sum()
  end

  def line_value(line) do
    digits = Regex.scan(~r/\d/, line) |> List.flatten()

    [Enum.at(digits, 0), Enum.at(digits, -1)]
    |> Enum.join()
    |> String.to_integer()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
  end
end

defmodule Day01.Part2 do
  @moduledoc """
  Documentation for `Day01.Part1`.
  """

  def solve(input) do
    input
    |> Day01.Part1.parse_input()
    # ...
  end

end

defmodule Mix.Tasks.Day01 do
  use Mix.Task

  def run(_) do
    demo_input = "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet\n"

    # input_filename = "inputs/day01.txt"
    # input_filename = "inputs/demo-input.txt"
    # {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(Day01.Part1.solve(demo_input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day01.Part2.solve(input))
  end
end
