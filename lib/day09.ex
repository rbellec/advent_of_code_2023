# I avoided doing the math and think it would take more time if I had to confront the basic of
# integration against just working with addition and iterations.
# I initially wanted to work with Elixir Stream, but I completely misunderstood how they works.
# Stream does not "consume" when you get their elements.
# iex(16)> stream=Stream.iterate(1, fn previous -> (previous + 1) end)
# Function<63.53678557/2 in Stream.unfold/2>
# iex(17)> stream |> Enum.take(10)
# [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# iex(18)> stream |> Enum.take(10)
# [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
#
# Where 0 expected the second call to start at 11.
# So I came back to a simple recursive “integration".

defmodule Day09 do
  defmodule Parser do
    import Enum

    def parse(input) do
      input
      |> String.split("\n", trim: true)
      |> map(fn line -> String.split(line, " ") |> map(&String.to_integer(&1)) end)
    end
  end

  defmodule Part1 do
    def discrete_derivative(list) do
      Enum.zip_reduce(list, tl(list), [], &[&2 - &1 | &3])
      |> Enum.reverse()
    end

    # Take a list and return all derivative till resul is a list of 0 or empty list.
    # Note that in the result the first list is the 0 (or empty) one and last list is the initial one.
    def all_derivations(list) do
      Enum.reduce_while(list, [list], fn _, derivatives ->
        case hd(derivatives) do
          [] ->
            {:halt, derivatives}

          # See if a guard can check this condition
          last_step ->
            if Enum.all?(last_step, &(0 == &1)) do
              {:halt, derivatives}
            else
              {:cont, [discrete_derivative(last_step) | derivatives]}
            end
        end
      end)
    end

    def rebuild(_, []) do
      []
    end

    # rebuild(5, [1, 2, 3]) returns [6, 8, 11].
    # initial value must be placed in front by the calling function.
    def rebuild(previous_value, [increment | tail]) do
      current_value = previous_value + increment
      [current_value | rebuild(current_value, tail)]
    end

    # Rebuild just adding a 0
    def rebuild_from_derivations([zeros | derivatives]) do
      List.foldl(derivatives, zeros, fn [initial_value | _], previous_integral_stream ->
        [initial_value | rebuild(initial_value, previous_integral_stream)]
      end)
    end

    def add_a_0_and_rebuild([zeros | derivatives]) do
      rebuild_from_derivations([[0 | zeros] | derivatives])
    end

    # Code kept to help reader undestand
    def solve_line(line) do
      line
      |> all_derivations()
      |> add_a_0_and_rebuild()
    end

    def solve(input) do
      res =
        input
        |> Day09.Parser.parse()
        |> Enum.map(&solve_line/1)
        |> Enum.map(&List.last/1)
        |> Enum.sum()
    end
  end

  defmodule Part2 do
    def solve(input) do
      res =
        input
        |> Day09.Parser.parse()
        |> Enum.map(&Enum.reverse/1)
        |> Enum.map(&Part1.solve_line/1)
        |> Enum.map(&List.last/1)
        |> Enum.sum()
    end
  end
end

defmodule Mix.Tasks.Day09 do
  use Mix.Task

  def run(_) do
    input_filename = "inputs/day09.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(to_string(Day09.Part1.solve(input)))

    # IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(to_string(Day09.Part2.solve(input)))
  end
end
