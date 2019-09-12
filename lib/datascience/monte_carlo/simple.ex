defmodule Datascience.MonteCarlo.Simple do
  @review_limit 10000
  @business_limit 1000

  def preview(:review), do: read_review() |> Enum.take(10) |> IO.inspect
  def preview(:business), do: read_business() |> Enum.take(10) |> IO.inspect
  def preview(:business_category), do: read_business_category() |> Enum.take(10) |> IO.inspect

  # list of {business_id, "Review text."}
  def read_review do
    path = Datascience.Yelp.Reader.review(:path)
    content = File.read!(path)

    content
    |> String.split("\n")
    |> Enum.take(@review_limit)
    |> Enum.reject(& is_nil(&1) or &1 == "")
    |> Enum.map(&Jason.decode!/1)
    |> Enum.map(fn record ->
      business_id = record["business_id"]
      text = record["text"]
      {business_id, text}
    end)
  end

  # %{bisuness_id => %MapSet{"cat1", cat2"}}
  def read_business_category do
    path = Datascience.Yelp.Reader.business(:path)
    content = File.read!(path)

    content
    |> String.split("\n")
    |> Enum.take(@business_limit)
    |> Enum.reject(& is_nil(&1) or &1 == "")
    |> Enum.map(&Jason.decode!/1)
    |> Enum.reject(&is_nil(&1["categories"]))
    |> Enum.reduce(%{}, fn record, acc ->
      business_id = record["business_id"]
      categories = record["categories"] |> String.split(", ")
      set = Map.get(acc, business_id)
      new_set = if is_nil(set) do
        MapSet.new(categories)
      else
        categories |> Enum.reduce(set, fn cat, s ->
          s |> MapSet.put(cat)
        end)
      end
      acc |> Map.put(business_id, new_set)
    end)
  end

  # list of {business_id, ["category1", "category2"]}
  def read_business do
    path = Datascience.Yelp.Reader.business(:path)
    content = File.read!(path)

    content
    |> String.split("\n")
    |> Enum.take(@business_limit)
    |> Enum.reject(& is_nil(&1) or &1 == "")
    |> Enum.map(&Jason.decode!/1)
    |> Enum.reject(&is_nil(&1["categories"]))
    |> Enum.map(fn record ->
      id = record["business_id"]
      categories = record["categories"] |> String.split(", ")
      {id, categories}
    end)
  end

end
