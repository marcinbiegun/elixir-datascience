defmodule Datascience.Yelp do
  def path(:business), do: File.cwd! <> "/data/yelp_dataset/business.json"
  def path(:review), do: File.cwd! <> "/data/yelp_dataset/review.json"
  def path(:photo), do: File.cwd! <> "/data/yelp_dataset/photo.json"
end
