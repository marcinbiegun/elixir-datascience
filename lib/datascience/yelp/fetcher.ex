defmodule Datascience.Yelp.Fetcher do
  alias Datascience.Yelp.Reader
  alias Datascience.Yelp.Parser

  def business(:all) do
    Reader.business(:json_all)
    |> String.split("\n")
    |> Parser.business
  end
end
