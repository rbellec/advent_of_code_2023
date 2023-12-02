defmodule DayO2Test do
  use ExUnit.Case
  import Day02.GameParser

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
end
