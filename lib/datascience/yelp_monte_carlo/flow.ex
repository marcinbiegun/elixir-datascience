defmodule Datascience.YelpMonteCarlo.Flow do
  alias Datascience.MonteCarlo
  alias Datascience.Yelp.Reader

  @review_limit 10000
  @business_limit 1000

  def compute do
    # TODO
    File.stream!(Reader.review(:path))
    |> Flow.from_enumerable
    |> Flow.flat_map()

    File.stream!(Reader.review(:path))
    Enum.take(@review_limit)
    |> Enum.reject(& is_nil(&1) or &1 == "")
    |> Enum.map(&Jason.decode!/1)
    |> Enum.map(fn record ->
      business_id = record["business_id"]
      text = record["text"]
      {business_id, text}
    end)
  end

end
