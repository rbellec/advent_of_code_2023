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

    def next_element_in(stream) do
      stream
      |> Enum.take(1)
      |> hd
    end

    def integrale_stream(initial_constant, previous_stream) do
      # fn previous_value -> next_element_in(previous_stream) + previous_value end
      Stream.iterate(initial_constant, &(next_element_in(previous_stream) + &1))
    end

    def zero_stream do
      Stream.repeatedly(fn -> 0 end)
    end

    def rebuilt_from_derivations([zeros | derivatives]) do
      List.foldl(derivatives, zero_stream(), fn [initial_value| _], previous_integral_stream ->
        integrale_stream(initial_value, previous_integral_stream)
      end)
    end

    # Code kept to help reader undestand
    def solve_line(line) do
      line
      |> all_derivations()
      |> rebuilt_from_derivations()
      |> Enum.fetch(Enum.count(line)) # 0 based !!
      |> elem(1)
    end

    def solved_line(line) do
      line
      |> all_derivations()
      |> rebuilt_from_derivations()
      |> Enum.take(1 + Enum.count(line))
    end

  end
end
