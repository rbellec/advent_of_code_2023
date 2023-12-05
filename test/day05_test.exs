defmodule DayO5Test do
  use ExUnit.Case

  setup do
    seed_line = "seeds: 79 14 55 13"
    location_line = "seed-to-soil map:"
    range_line = "0 15 37"

    garden_function_def = """
    seed-to-soil map:
    50 98 2
    52 50 48
    """

    demo_input_aoc = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

    %{
      seed_line: seed_line,
      location_line: location_line,
      range_line: range_line,
      garden_function_def: garden_function_def,
      demo_input_aoc: demo_input_aoc
    }
  end

  describe "Day 05 parsing" do
    import Day05.Parser

    test "Parse cases", context do
      seed = seeds(context.seed_line) |> elem(1)
      location = location_names(context.location_line) |> elem(1)
      loc_string = misc_string("seed-to-soil map:")
      range = range_definition(context.range_line) |> elem(1)
      # require IEx; IEx.pry

      # Intermediate parser
      assert(:ok = loc_string |> elem(0))
      # ":" remain to parse after.
      assert(":" = loc_string |> elem(2))

      assert(seeds: [79, 14, 55, 13])
      assert(["seed-to-soil map", ":"] = location)
      assert([destination: 0, source: 15, length: 37] = range)
    end

    test "parse a between location function", context do
      parsed_result = garden_function(context.garden_function_def) |> elem(1)

      expected = [
        %Day05.GardenFunctionElement{
          from: nil,
          to: nil,
          offset: -48,
          length: 2,
          source: 98,
          destination: 50
        },
        %Day05.GardenFunctionElement{
          from: nil,
          to: nil,
          offset: 2,
          length: 48,
          source: 50,
          destination: 52
        }
      ]
      assert(expected = parsed_result)
    end

    test "parse file", context do
      parsed_result = file(context.demo_input_aoc) |> elem(1)
      require IEx; IEx.pry
    end

  end
end
