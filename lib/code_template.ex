defmodule Day0.Parser do
end

defmodule Day0.Part1 do
  # Try to use Pathex every time ?
  # import Pathex
  # import Pathex.Lenses
  @moduledoc """
  Documentation for `Day01.Part1`.
  """

  def solve(input) do
    input
    |> parse_input()

    # ...
  end

  def parse_input(input) do
    input
    |> String.split("\n\n")

    # ...
  end
end

defmodule Day0.Part2 do
  @moduledoc """
  Documentation for `Day01.Part1`.
  """

  # def solve(input) do
  #   input
  #   |> Day0.Part1.parse_input()

  #   # ...
  # end
end

defmodule Mix.Tasks.Day0 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    input_filename = "inputs/day00.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(Day0.Part1.solve(input))
    IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day0.Part2.solve(input))
  end
end
