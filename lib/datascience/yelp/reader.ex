defmodule Datascience.Yelp.Reader do
  def business(:json_all) do
    file_path = File.cwd! <> "/data/yelp/business.json"
    {:ok, file} = File.open(file_path, [:read])
    content = IO.read(file, :all)
    content
  end
end
