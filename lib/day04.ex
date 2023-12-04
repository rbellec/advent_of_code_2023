# defmodule Day04.Game do
#   defstruct [:index, winnings: [], draw:[]]
# end

defmodule Day04.Parser do
  import NimbleParsec

  def to_map(list) do
    Enum.into(list, %{})
  end

  spaces = times(string(" "), min: 1)
  eol = choice([string("\r\n"), string("\n")])

  pipe_sep = ignore(spaces) |> string("|")
  colon = string(":")
  number = ignore(spaces) |> integer(min: 1)

  line =
    ignore(string("Card"))
    |> (concat(number) |> unwrap_and_tag(:index))
    |> ignore(colon)
    |> concat(times(number, min: 1) |> tag(:winnings))
    |> ignore(pipe_sep)
    |> concat(times(number, min: 1) |> tag(:your_draw))
    |> ignore(optional(eol))

  # Ok
  game = times(line |> wrap, min: 1) |> map(:to_map) |> eos

  defparsec(:line, line)
  defparsec(:game, game)
end

defmodule Day04.Part1 do
  # Try to use Pathex every time ?
  # import Pathex
  # import Pathex.Lenses
  @moduledoc """
  Documentation for `Day01.Part1`.
  """

  def solve(input) do
    input
    |> Day04.Parser.game()
    |> elem(1)
    |> Enum.map(&score_game/1)
    |> Enum.sum()
  end

  def score_game(game_map) do
    # elements may be present multiple times ?
    winnings = MapSet.new(game_map.winnings)

    won_draws =
      game_map.your_draw
      |> Enum.map(fn elem ->
        if MapSet.member?(winnings, elem) do
          1
        else
          0
        end
      end)
      |> Enum.sum()

    if won_draws == 0 do
      0
    else
      2 ** (won_draws - 1)
    end
  end
end

defmodule Day04.Part2 do
  @moduledoc """
  Documentation for `Day01.Part1`.
  """

  # def solve(input) do
  #   input
  #   |> Day0.Part1.parse_input()

  #   # ...
  # end
end

defmodule Mix.Tasks.Day04 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    input_filename = "inputs/day04.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(Day04.Part1.solve(input))
    IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day04.Part2.solve(input))
  end
end
