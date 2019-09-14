defmodule Datascience.MonteCarlo do
  # ------------ start generation

  def generate(data, amount \\ 10) do
    words = [:start]
    tdata = transpose(data)
    add_word(words, tdata, amount)
  end

  def add_word(words, tdata, amount) do
    if length(words) >= amount do
      words |> Enum.join(" ")
    else
      last_word = List.last(words)
      generated_word = find_next_word(tdata, last_word)
      if generated_word == :end do
        words |> Enum.filter(& &1 != :start) |> Enum.join(" ")
      else
        add_word(words ++ [generated_word], tdata, amount)
      end
    end
  end

  def find_next_word(tdata, word) do
    word_tdata = Map.get(tdata, word)
    if is_nil(word_tdata), do: raise "No data for word: #{word}"

    rolled_index = word_tdata |> Map.keys |> roll_from_weights
    {_weight, word} = Enum.at(word_tdata, rolled_index)
    word
  end

  def roll_from_weights(weights) do
    sum = Enum.sum(weights)
    roll = Enum.random(1..sum)
    find_rolled(weights, roll)
  end

  def find_rolled([weight | weights], roll, acc \\ 0, index \\ 0) do
    acc = acc + weight
    if acc <= roll do
      index
    else
      find_rolled(weights, roll, acc, index + 1)
    end
  end

  def transpose(data) do
    data |> Enum.map(fn {word, word_data} ->
      new_word_data = word_data |> Enum.map(fn {k,v} -> {v,k} end) |> Map.new
      {word, new_word_data}
    end) |> Map.new
  end

  # ------------ end genration

  def add_text(data \\ %{}, text) do
    text = String.downcase(text)

    # Remove all except basic letters
    pairs = Regex.replace(~r/[^a-z ]/m, text, "")
    |> String.split(" ", trim: true)
    |> Enum.chunk_every(2, 1, :discard)

    # add :start
    pairs = [[:start, pairs |> Enum.at(0) |> Enum.at(0)]] ++ pairs

    # add :end
    pairs = pairs ++ [[pairs |> Enum.at(-1) |> Enum.at(1), :end]]

    Enum.reduce(pairs, data, fn [word0, word1], acc_data ->
      add_pair(acc_data, word0, word1)
    end)
  end

  def add_pair(data, word, next) do
    word_data = Map.get(data, word)

    new_word_data = if is_nil(word_data) do
      %{ next => 1 }
    else
      new_next_count = Map.get(word_data, next, 0) + 1
      word_data |> Map.put(next, new_next_count)
    end

    Map.put(data, word, new_word_data)
  end
end
