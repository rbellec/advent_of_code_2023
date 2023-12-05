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

    demo_functions = [
      %Day05.GardenFunctionElement{
        from: nil,
        to: nil,
        offset: -48,
        length: 2,
        source: 98,
        destination: 50,
        image_range: 50..51,
        input_range: 98..99
      },
      %Day05.GardenFunctionElement{
        from: nil,
        to: nil,
        offset: 2,
        length: 48,
        source: 50,
        destination: 52,
        image_range: 52..99,
        input_range: 50..97
      }
    ]

    demo_functions_2 = [
      %Day05.GardenFunctionElement{
        from: nil,
        to: nil,
        offset: -15,
        length: 37,
        source: 15,
        destination: 0,
        input_range: 15..51,
        image_range: 0..36
      },
      %Day05.GardenFunctionElement{
        from: nil,
        to: nil,
        offset: -15,
        length: 2,
        source: 52,
        destination: 37,
        input_range: 52..53,
        image_range: 37..38
      },
      %Day05.GardenFunctionElement{
        from: nil,
        to: nil,
        offset: 39,
        length: 15,
        source: 0,
        destination: 39,
        input_range: 0..14,
        image_range: 39..53
      }
    ]

    %{
      seed_line: seed_line,
      location_line: location_line,
      range_line: range_line,
      garden_function_def: garden_function_def,
      demo_input_aoc: demo_input_aoc,
      demo_functions: demo_functions,
      demo_functions_2: demo_functions_2
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

      assert([seeds: [79, 14, 55, 13]] = seed)
      assert(["seed-to-soil map", ":"] = location)
      assert([destination: 0, source: 15, length: 37] = range)
    end

    test "parse a between location function", context do
      parsed_result = garden_function(context.garden_function_def) |> elem(1)

      assert(context.demo_functions == parsed_result)
    end

    test "parse file", _context do
      # parsed_result = file(context.demo_input_aoc) |> elem(1)
      # require IEx; IEx.pry
      # Parse is ok and no time to unit test it.
    end

  end

  # describe "Compose offset on range functions" do
  #   # Range 1    |-------------|
  #   # on Range 2       |-------------|
  #   #
  #   test "simple application on two intersecting ranges", _context do

  #   end
  # end

  describe "applying garden functions" do
    import Day05.GardenFunctionElement
    test "apply one", context do
      # source: 98, destination: 50, offset: -48, length: 2
      # require IEx; IEx.pry
      assert( apply_one(Enum.at(context.demo_functions, 0),  97) == nil )
      assert( apply_one(Enum.at(context.demo_functions, 0),  98) == 50 )
      assert( apply_one(Enum.at(context.demo_functions, 0),  99) == 51 )
      assert( apply_one(Enum.at(context.demo_functions, 0), 100) == nil )

      assert( apply_one(Enum.at(context.demo_functions, 1),  49) == nil )
      assert( apply_one(Enum.at(context.demo_functions, 1),  50) == 52 )
    end

    test "apply_garden_fun", context do
      # require IEx; IEx.pry
      assert( apply_garden_fun(context.demo_functions, 98) == [50] )
      assert( apply_garden_fun(context.demo_functions, 50) == [52] )
      assert( apply_garden_fun(context.demo_functions, 10) == [10] )

      assert( apply_garden_fun(context.demo_functions_2, 81) == [81] )
    end

    test "apply_garden_fun to a list of seed", context do
      # require IEx; IEx.pry
      test = fn data, expected ->
        apply_garden_fun_to_locations(context.demo_functions, data) == expected
      end
      assert(test.([1, 2, 3], [1, 2, 3]))
      assert(test.([1, 98], [1, 50]))
      assert(test.([1, 98, 50], [1, 50, 52]))
      assert(test.([79, 14, 55, 13], [81, 14, 57, 13]))
    end
  end

  test "solve", context do
    result = Day05.Part1.solve(context.demo_input_aoc)
  end
end
