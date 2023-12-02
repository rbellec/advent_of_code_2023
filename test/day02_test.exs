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
    assert(pr(color_draw("10 red")) == [10, :red])
    assert(pr(color_draw("15 blue, ")) == [15, :blue])
  end

  # test "one draw" do
  #   assert(pr(single_draw("10 red, 15 blue, 3 green")) == [10, :red])
  #   assert(pr(color_draw("15 blue, ")) == [15, :blue])
  # end
end
