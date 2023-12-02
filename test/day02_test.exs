defmodule DayO2Test do
  use ExUnit.Case

  # pr for parse result
  def pr(result_tuple) do
    elem(result_tuple, 1)
  end

  test "parse color" do
    assert({:ok, [:red], _, _, _, _} = Day02.GameParser.color("red"))
    assert({:ok, [:blue], _, _, _, _} = Day02.GameParser.color("blue"))
    assert({:ok, [:green], _, _, _, _} = Day02.GameParser.color("green"))
  end

  test "parse color draw" do
    assert(pr(Day02.GameParser.color_draw("10 red")) == [10, :red])
  end
end
