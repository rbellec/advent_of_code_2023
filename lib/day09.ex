# I initially wanted to work with Elixir Stream, but I completely misunderstood how they works.
# Stream does not "consume" when you get their elements.
# iex(16)> stream=Stream.iterate(1, fn previous -> (previous + 1) end)
#Function<63.53678557/2 in Stream.unfold/2>
# iex(17)> stream |> Enum.take(10)
# [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# iex(18)> stream |> Enum.take(10)
# [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
#
# Where 0 expected the second call to start at 11.

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

    # Stream does not work as I expected. stream |> Enum.take(5) will return the 5 first elements of stream everytime and not "consume" them.
    # def next_element_in(stream) do
    #   stream
    #   |> Enum.take(1)
    #   |> hd
    # end

    # def integrale_stream(initial_constant, previous_stream) do
    #   next_value_generator = fn
    #     previous_value -> previous_value + next_element_in(previous_stream)
    #   end
    #   # require IEx; IEx.pry()
    #   Stream.iterate(initial_constant, &(next_value_generator.(&1)))
    #   # require IEx; IEx.pry()
    # end

    # def zero_stream do
    #   Stream.repeatedly(fn -> 0 end)
    # end

    def rebuild(_, []) do
      []
    end

    def rebuild(previous_value, [increment|tail]) do
      current_value = previous_value + increment
      [ current_value | rebuild(current_value, tail)]
    end

    def rebuild_from_derivations([zeros | derivatives]) do
      List.foldl(derivatives, zeros, fn [initial_value | _], previous_integral_stream ->
        rebuild(initial_value, previous_integral_stream)
      end)
    end

    # Code kept to help reader undestand
    def solve_line(line) do
      line
      |> all_derivations()
      |> rebuild_from_derivations()
      # 0 based !!
      # |> Enum.fetch(Enum.count(line))
      # |> elem(1)
    end


    def solve(input) do
      res =
        input
        |> Day09.Parser.parse()
        |> Enum.map(&solve_line/1)

      require IEx
      IEx.pry(); res |> Enum.sum()
    end
  end

  defmodule Part1.TestStreams do


  end
end
