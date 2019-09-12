defmodule Datascience.Yelp.Reader do
  def business(:path), do: File.cwd! <> "/data/yelp_dataset/business.json"
  def review(:path), do: File.cwd! <> "/data/yelp_dataset/review.json"
end
