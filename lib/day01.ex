defmodule Day01.Part1 do
  # import Pathex
  # import Pathex.Lenses
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
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&line_value/1)
    # |> Enum.join("\n")
    |> Enum.sum()
  end

  def line_value(line) do
    # Trick : some lines have only one digit. Some numbers overlaps, ex: oneight
    # This is the version without considering this since I would like to test unit testing in elixir for thoses cases
    # I did not find how to capture all overlapping subexpressions in a string yet, will take just first and last probably using lookahead.
    # de : digit expression
    de = "[[:digit:]]|one|two|three|four|five|six|seven|eight|nine"
    digits = Regex.scan(~r/#{de}/, line)|> Enum.map(&(Enum.at(&1, 0)))

    [head|tail] = digits

    [head, Enum.at(tail, -1)]
    |> Enum.map(&number_to_digit/1)
    |> Enum.join()
    |> String.to_integer()
  end

  def number_to_digit(string) do
    case string do
      nil -> ""
      "one" -> "1"
      "two" -> "2"
      "three" -> "3"
      "four" -> "4"
      "five" -> "5"
      "six" -> "6"
      "seven" -> "7"
      "eight" -> "8"
      "nine" -> "9"
      _ -> string
    end
  end

end

defmodule Mix.Tasks.Day01 do
  use Mix.Task

  def run(_) do
    # {:ok, input} = File.read("inputs/demo-input.txt")
    # input = "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet\n"
    # input = "two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen\n"

    input_filename = "inputs/day01.txt"
    {:ok, input} = File.read(input_filename)

    # IO.puts("--- Part 1 ---")
    # IO.puts(Day01.Part1.solve(input))
    # IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day01.Part2.solve(input))
  end
end
