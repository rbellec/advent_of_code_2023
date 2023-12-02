defmodule Day02.GameParser do
  import NimbleParsec
  # Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green

  space = string(" ")
  eol = choice([string("\r\n"), string("\n")])
  comma = string(", ")
  semicolon = string("; ")

  red = string("red") |> replace(:red)
  green = string("green") |> replace(:green)
  blue = string("blue") |> replace(:blue)

  # color = choice([red, green, blue]) |> unwrap_and_tag(:color)
  color = choice([red, green, blue])
  quantity = integer(min: 1) |> unwrap_and_tag(:quantity)

  color_draw =
    quantity
    |> ignore(space)
    |> concat(color |> unwrap_and_tag(:color))
    |> ignore(optional(comma))

  single_draw = times(color_draw |> wrap, min: 1) |> ignore(optional(semicolon)) |> tag(:draw)
  game_draws = times(single_draw, min: 1) |> tag(:draws)

  game =
    ignore(string("Game "))
    |> (integer(min: 1) |> unwrap_and_tag(:index))
    |> ignore(string(": "))
    |> concat(game_draws)
    |> ignore(optional(eol))

  games_list = times(game |> wrap, min: 1) |> eos
  # Day02.GameParser.game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")

  defparsec(:color, color)
  defparsec(:color_draw, color_draw, debug: false)
  defparsec(:single_draw, single_draw)
  defparsec(:game_draws, game_draws)
  defparsec(:game, game)
  defparsec(:games_list, games_list)
end

defmodule Day02.Part1 do
  import Pathex
  import Pathex.Lenses

  def solve(games) do
    draws = all() ~> path(:draws) ~> all()
    # Pathex.over(game, draws, valid_draw/1)

    # view(games, draws ~> quantities_in_draws)
    # quantities = view(games, all() ~> path(:draws) ~> all() ~> all() ~> path(:quantity))
    # path_to_draws =  all ~> path(1)
    # view(games, all ~> path(1))
  end

  # [[quantity: 1, color: :green], [quantity: 3, color: :red], [quantity: 6, color: :blue]]
  def valid_draw(draw) do
    quantities_in_draws = all() ~> path(:quantity)
    total = view!(draw, quantities_in_draws) |> Enum.sum()
    total <= 20
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
    games = elem(Day02.GameParser.games_list(input), 1)

    IO.puts("--- Part 1 ---")
    IO.puts(Day02.Part1.solve(input))

    demo_struct = [
      index: 1,
      draws: [
        draw: [[quantity: 3, color: :blue], [quantity: 4, color: :red]],
        draw: [
          [quantity: 1, color: :red],
          [quantity: 2, color: :green],
          [quantity: 6, color: :blue]
        ],
        draw: [[quantity: 2, color: :green]]
      ]
    ]
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day02.Part2.solve(input))
  end
end
