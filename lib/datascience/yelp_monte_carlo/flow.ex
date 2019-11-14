defmodule Datascience.YelpMonteCarlo.Flow do

  def debug do
    # count_reviews(business_ids) |> IO.puts # 805s (79_399 items)
    # popular_categories() |> IO.puts # 7s (1_300 items)

    business_ids = read_business_ids("Pets") # 7s (4_111 items)
    data = feed_reviews_to_montecarlo(business_ids) # 848s

    Datascience.MonteCarlo.generate(data) |> IO.puts
  end

  def popular_categories do
    File.stream!(Datascience.Yelp.path(:business))
    |> Flow.from_enumerable()
    |> Flow.map(&Jason.decode!/1)
    |> Flow.flat_map(fn business ->
      if is_binary(business["categories"]) do
        String.split(business["categories"], ", ")
      else
        []
      end
    end)
    |> Enum.reduce(%{}, fn category, acc ->
      Map.update(acc, category, 1, & &1 + 1)
    end)
    |> Enum.sort(fn {_cat1, count1}, {_cat2, count2} -> count1 > count2 end)
  end

  def count_reviews(business_ids) do
    File.stream!(Datascience.Yelp.path(:review))
    |> Flow.from_enumerable()
    |> Flow.map(&Jason.decode!/1)
    |> Flow.map(fn review ->
      if review["business_id"] in business_ids do
        1
      else
        0
      end
    end)
    |> Enum.to_list
    |> Enum.sum
  end

  def feed_reviews_to_montecarlo(business_ids) do
    File.stream!(Datascience.Yelp.path(:review))
    |> Flow.from_enumerable()
    |> Flow.map(&Jason.decode!/1)
    |> Flow.flat_map(fn review ->
      if review["business_id"] in business_ids do
        Datascience.MonteCarlo.text_to_pairs(review["text"])
      else
        []
      end
    end)
    #|> Enum.take(1000)
    |> Enum.to_list
    |> Enum.reduce(%{}, fn [word1, word2], acc ->
      Datascience.MonteCarlo.add_pair(acc, word1, word2)
    end)
  end

  def read_business_ids(category) do
    File.stream!(Datascience.Yelp.path(:business))
    |> Flow.from_enumerable()
    |> Flow.map(&Jason.decode!/1)
    |> Flow.map(fn business ->
      if is_binary(business["categories"]) do
        categories = String.split(business["categories"], ", ")
        if category in categories do
          business["business_id"]
        else
          nil
        end
      else
        nil
      end
    end)
    |> Enum.to_list
    |> Enum.reject(&is_nil/1)
  end

end
