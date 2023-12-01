defmodule DayO1Test do
  use ExUnit.Case
  doctest AdventOfCode2023

  test "Part 2 match example lines" do
    cases = [ ["two1nine", 29],
      ["eightwothree", 83],
      ["abcone2threexyz", 13],
      ["xtwone3four", 24],
      ["4nineeightseven2", 42],
      ["zoneight234", 14],
      ["7pqrstsixteen", 76]]

    cases
    |> Enum.each(fn ([line, result]) ->
        assert(Day01.Part2.line_value(line) == result)
      end)
  end

  test "match lines with one number" do
    cases = [ ["two1nine", 29],
      ["4md", 4],
      ["abconeexyz", 1],
      ["xtofour", 4]]

    Enum.each(cases, fn ([line, result]) ->
        assert(Day01.Part2.line_value(line) == result)
      end)
  end

  test "overlapping alphanumeric numbers" do
    cases = [ ["oneight", 18],
      ["eightwo", 82],
      ["sevenine", 79]]

    Enum.each(cases, fn ([line, result]) ->
        assert(Day01.Part2.line_value(line) == result)
      end)
  end
  # remain overlapping, like oneight
end
