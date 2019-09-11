defmodule Datascience.Yelp.Parser do
  alias Datascience.Yelp.Business

  def business(json) do
    record = Jason.decode!(json)
    Business.new([
      business_id: record |> Map.get("business_id"),
      name: record |> Map.get("name"),
      categories: record |> Map.get("categories") |> String.split(", ")
    ])
  end
end
