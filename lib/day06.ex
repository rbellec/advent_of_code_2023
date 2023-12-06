defmodule Day06 do
  defmodule Parser do
    import Enum

    def parse(input) do
      lists =
        String.split(input, "\n", trim: true)
        |> map(fn line ->
          Regex.scan(~r/\d+/, line) |> map(&String.to_integer(hd(&1)))
        end)

      [times, distances] = lists
      zip(times, distances)
    end
  end

  defmodule Part1 do
    import Enum

    def solve(input) do
      Parser.parse(input)
      |> map(&solve_race/1)
      |> reduce(&(&1 * &2))

    end

    def solve_race({time, record}) do
      #Beating the record means going further !
      epsilon = 0.000001
      distance = record + epsilon

      delta = time ** 2 - 4 * distance

      cond do
        # No solution for this race.
        delta < 0 ->
          nil

        # Only one solution.
        delta == 0 ->
          1

        true ->
          solutions = [(time - :math.sqrt(delta)) / 2, (time + :math.sqrt(delta)) / 2]

          sup = Float.floor(max(solutions))
          inf = Float.ceil(min(solutions))

          # dbg = [solutions, sup, inf]
          # require IEx; IEx.pry
          trunc(sup - inf + 1)
      end
    end
  end

  defmodule Part2 do
    def solve do
      # no time to adapt parse. Done by hand.
      race = {59688274, 543102016641022}
      Part1.solve_race(race)
    end
  end
end

defmodule Mix.Tasks.Day06 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    input_filename = "inputs/day06.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(Day06.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day06.Part2.solve)
  end
end
