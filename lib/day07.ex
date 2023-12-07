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
    defstruct [:text_hand, :cards, :bet, :hand_value, :hand_name, :quantity_by_card_values]

    def parse_hand([text_hand, bet]) do
      cards = String.graphemes(text_hand) |> Enum.map(&card_value/1)
      {hand_value, hand_name, quantity_by_card_values} = value_hand(cards)

      %Hand{
        text_hand: text_hand,
        cards: cards,
        bet: String.to_integer(bet),
        hand_value: hand_value,
        hand_name: hand_name,
        quantity_by_card_values: quantity_by_card_values
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

    # Return {hand score, hand name}
    def value_hand(cards) do
      # Create a map with {card_value => number_of_cards}
      quantity_by_card_values =
        Enum.reduce(cards, %{}, fn value, tally_map ->
          Map.get_and_update(tally_map, value, fn
            nil -> {nil, 1}
            previous -> {previous, previous + 1}
          end)
          |> elem(1)
        end)

      hand_name =
        Map.values(quantity_by_card_values)
        |> Enum.sort()
        |> case do
          [5] -> {7, :five_of_a_kind}
          [1, 4] -> {6, :four_of_a_kind}
          [2, 3] -> {5, :full}
          [1, 1, 3] -> {4, :brelan}
          [1, 2, 2] -> {3, :two_pairs}
          [1, 1, 1, 2] -> {2, :pair}
          [1, 1, 1, 1, 1] -> {1, :high_card}
        end

      # # Cards in order of relevance in the end.
      # hand_composition =
      #   Enum.sort(cards, fn a, b ->
      #     num_a = Map.get(quantity_by_card_values, a)
      #     num_b = Map.get(quantity_by_card_values, b)

      #     if num_a == num_b do
      #       a <= b
      #     else
      #       num_a < num_b
      #     end
      #   end)
      #   |> Enum.dedup()
      #   |> Enum.reverse()

      hand_name
      |> Tuple.append(quantity_by_card_values)
    end

    # True if hands a < b, false otherwise.
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
        a.hand_value < b.hand_value
      end
    end

    def print_hand(hand) do
      # IO.puts("#{hand.hand_value}: \t#{hand.text_hand}, \t[#{Enum.join(hand.cards, ", ")}] \t#{hand.hand_name}")
      IO.puts("#{hand.text_hand} #{hand.bet}")
    end
  end

  defmodule Part1 do
    import Enum

    def print_order(input) do
      Parser.parse(input)
      |> sort(&Hand.compare_hands/2)
      |> Enum.each(&Day07.Hand.print_hand/1)
    end

    def solve(input) do
      Parser.parse(input)
      |> sort(&Hand.compare_hands/2)
      |> map(& &1.bet)
      |> with_index(&(&1 * (&2 + 1)))
      |> sum()
    end
  end

  defmodule Part2 do
    import Enum
    # Modify a hand for part 2.
    # -> Joker now worh 0
    # -> all joker are replaced by the card with most occurence after joker, unless there are 5 jokers.
    # -> card type is now calculated with jokers.
    def value_hands_for_part_2(hand) do
      jack = 11

      # Order card by their number of occurence. Take the first that is not a joker (unless there are only jokers)

      joker_value = Enum.sort_by(hand.cards, &Map.get(hand.quantity_by_card_values, &1), :desc)
      |> Enum.dedup
      |> case do
          [^jack] -> jack
          [^jack, other | _] -> other
          [other | _] -> other
        end

        # require IEx; IEx.pry()

      # a replace all jockers by this one before evaluating this hand again. (event in case it's JJJJJ case)
      evaluation_cards =
        map(hand.cards, fn
          ^jack -> joker_value
          other -> other
        end)

      new_cards =
        map(hand.cards, fn
          ^jack -> 0
          other -> other
        end)

      {hand_value, hand_name, _} = Hand.value_hand(evaluation_cards)

      hand
      |> Map.put(:hand_value, hand_value)
      |> Map.put(:hand_name, hand_name)
      |> Map.put(:cards, new_cards)
    end

    def print_order(input) do
      Parser.parse(input)
      |> map(&value_hands_for_part_2/1)
      |> sort(&Hand.compare_hands/2)
      |> Enum.each(&Day07.Hand.print_hand/1)
    end

    def solve(input) do
      Parser.parse(input)
      |> map(&value_hands_for_part_2/1)
      |> sort(&Hand.compare_hands/2)
      |> map(& &1.bet)
      |> with_index(&(&1 * (&2 + 1)))
      |> sum()
    end
  end
end

defmodule Mix.Tasks.Day07 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    input_filename = "inputs/day07.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    # IO.puts(Day07.Part1.print_order(input))
    IO.puts(Day07.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    # IO.puts(Day07.Part2.print_order(input))
    IO.puts(Day07.Part2.solve(input))
  end
end
