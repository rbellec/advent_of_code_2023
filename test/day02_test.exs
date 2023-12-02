defmodule DayO2Test do
  use ExUnit.Case

  test "parse color" do
    assert({:ok, [color: "red"], _, _, _, _} = Day02.GameParser.color("red"))
    assert({:ok, [color: "blue"], _, _, _, _} = Day02.GameParser.color("blue"))
    assert({:ok, [color: "green"], _, _, _, _} = Day02.GameParser.color("green"))
  end
end
