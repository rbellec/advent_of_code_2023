defmodule DayO2Test do
  use ExUnit.Case
  import Day02.GameParser
  import Pathex
  import Pathex.Lenses

  # pr for parse result
  def pr(result_tuple) do
    elem(result_tuple, 1)
  end

  test "parse color" do
    assert({:ok, [:red], _, _, _, _} = color("red"))
    assert({:ok, [:blue], _, _, _, _} = color("blue"))
    assert({:ok, [:green], _, _, _, _} = color("green"))
  end

  test "parse color draw" do
    assert(pr(color_draw("10 red")) == [quantity: 10, color: :red])
    assert(pr(color_draw("15 blue, ")) == [quantity: 15, color: :blue])
  end

  test "one draw" do
    draw = [
      draw: [
        [quantity: 10, color: :red],
        [quantity: 15, color: :blue],
        [quantity: 3, color: :green]
      ]
    ]

    assert(pr(single_draw("10 red, 15 blue, 3 green")) == draw)
    assert(pr(single_draw("10 red, 15 blue, 3 green; ")) == draw)
  end

  test "game draws" do
    game_description = [
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

    assert(pr(game_draws("3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")) == game_description)
  end

  # Day02.GameParser.game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
  test "parse game line" do
    game = [
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

    assert(pr(game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")) == game)
    assert(pr(game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\n")) == game)
  end

  test "access quantities in draws" do
    # check how to access directly from module.
    quantities_in_draws = all() ~> path(:quantity)
    draw = [[quantity: 1, color: :green], [quantity: 3, color: :red], [quantity: 6, color: :blue]]
    assert({_, [1, 3, 6]} = Pathex.view(draw, quantities_in_draws))
  end

  # only 12 red cubes, 13 green cubes, and 14 blue cubes?
  test "valid draw" do
    draw_1 = [
      [quantity: 1, color: :green],
      [quantity: 3, color: :red],
      [quantity: 6, color: :blue]
    ]

    valid_draw_2 = [
      [quantity: 12, color: :red],
      [quantity: 13, color: :green],
      [quantity: 14, color: :blue]
    ]

    invalid_draw_1 = [
      [quantity: 13, color: :red],
      [quantity: 13, color: :green],
      [quantity: 14, color: :blue]
    ]

    assert(Day02.Part1.validate_draw(draw_1))
    assert(Day02.Part1.validate_draw(valid_draw_2))
    assert(!Day02.Part1.validate_draw(invalid_draw_1))
  end

  test "game is valid" do
    valid_game = [index: 1, draws: [draw: true, draw: true, draw: true]]
    invalid_game = [index: 1, draws: [draw: true, draw: true, draw: false]]
    assert(Day02.Part1.game_is_valid(valid_game))
    assert(!Day02.Part1.game_is_valid(invalid_game))
  end
end
