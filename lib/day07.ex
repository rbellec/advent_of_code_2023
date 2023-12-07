defmodule Day07 do
  defmodule Parser do
    def parse(input) do
      String.split(input, "\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, " ") |> Day07.Hand.parse_hand()
      end)
    end
  end

  defmodule Hand do
    defstruct [:text_hand, :cards, :bet, :hand_value, :hand_name]

    def parse_hand([text_hand, bet]) do
      cards = String.graphemes(text_hand) |> Enum.map(&card_value/1) |> Enum.sort(:desc)
      {hand_value, hand_name} = value_hand(cards)

      %Hand{
        text_hand: text_hand,
        cards: cards,
        bet: String.to_integer(bet),
        hand_value: hand_value,
        hand_name: hand_name
      }
    end

    def card_value(char) do
      case char do
        "T" -> 10
        "J" -> 11
        "Q" -> 12
        "K" -> 13
        "A" -> 14
        num -> String.to_integer(num)
      end
    end

    def value_hand(cards) do
      hand_counts =
        Enum.reduce(cards, %{}, fn value, tally_map ->
          Map.get_and_update(tally_map, value, fn
            nil -> {nil, 1}
            previous -> {previous, previous + 1}
          end)
          |> elem(1)
        end)

      # Kepts name because why not ?

      Map.values(hand_counts)
      |> Enum.sort()
      |> case do
        [5] -> {7, :five_of_a_kind}
        [1, 4] -> {6, :four_of_a_kind}
        [2, 3] -> {5, :full}
        [1, 1, 3] -> {4, :brelan}
        [1, 2, 2] -> {3, :two_pairs}
        [1, 1, 1, 2] -> {2, :pairs}
        [1, 1, 1, 1, 1] -> {1, :high_card}
      end
    end

    def compare_hands(a, b) do
      if a.hand_value == b.hand_value do
        Enum.zip(a.cards, b.cards)
        |> Enum.reduce_while(true, fn {a, b}, _acc ->
          cond do
            a == b -> {:cont, true}
            a < b -> {:halt, true}
            a > b -> {:halt, false}
          end
        end)
      else
        a.hand_value > b.hand_value
      end
    end
  end

  defmodule Part1 do
    import Enum

    def solve(input) do

        Parser.parse(input)
        |> sort(&Hand.compare_hands/2)
        |> map(& &1.bet)
        |> with_index(&(&1 * (&2 + 1)))
        |> sum()
    end
  end

  # defmodule Part2 do
  #   def solve do
  #   end
  # end
end

defmodule Mix.Tasks.Day07 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    input_filename = "inputs/day07.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(Day07.Part1.solve(input))
    IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day07.Part2.solve)
  end
end
