defmodule Datascience.MonteCarlo do
  @words_limit 50
  # ------------ start generation

  def generate(data) do
    words = [:start]
    tdata = transpose(data)
    add_word(words, tdata)
  end

  def add_word(words, tdata) do
    if length(words) >= @words_limit do
      words |> Enum.filter(& &1 != :start) |> Enum.join(" ")
    else
      last_word = List.last(words)
      generated_word = find_next_word(tdata, last_word)
      if generated_word == :end do
        words |> Enum.filter(& &1 != :start) |> Enum.join(" ")
      else
        add_word(words ++ [generated_word], tdata)
      end
    end
  end

  def find_next_word(tdata, word) do
    word_tdata = Map.get(tdata, word)
    if is_nil(word_tdata), do: raise "No data for word: #{word}"

    weights = word_tdata |> Map.keys
    rolled_index = roll_from_weights(weights)
    {_weight, word} = Enum.at(word_tdata, rolled_index)
    word
  end

  def roll_from_weights(weights) do
    sum = Enum.sum(weights)
    roll = Enum.random(0..sum)
    find_rolled(weights, roll)
  end

  def find_rolled([weight | weights], roll, acc \\ 0, index \\ 0) do
    acc = acc + weight
    if acc >= roll do
      index
    else
      find_rolled(weights, roll, acc + weight, index + 1)
    end
  end

  # Converts %{"Hello" => %{"World" => 1, :end => 1}}
  # into
  # Converts %{"Hello" => %{1 => "World", 1 => :end}}
  def transpose(data) do
    data |> Enum.map(fn {word, word_data} ->
      new_word_data = word_data |> Enum.map(fn {k,v} -> {v,k} end) |> Map.new
      {word, new_word_data}
    end) |> Map.new
  end

  # ------------ end genration

  def add_text(data \\ %{}, text) do
    text = String.downcase(text)
    text = Regex.replace(~r/[^a-z ]/m, text, "")

    pairs = text
    |> String.split(" ", trim: true)
    |> Enum.chunk_every(2, 1, :discard)

    if length(pairs) > 0 do
      pairs = [[:start, pairs |> Enum.at(0) |> Enum.at(0)]] ++ pairs
      pairs = pairs ++ [[pairs |> Enum.at(-1) |> Enum.at(1), :end]]
      Enum.reduce(pairs, data, fn [word0, word1], acc_data ->
        add_pair(acc_data, word0, word1)
      end)
    else
      data
    end
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
