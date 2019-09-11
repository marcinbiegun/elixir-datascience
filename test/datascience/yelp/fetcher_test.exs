defmodule Datascience.Yelp.FetcherTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates new record" do
      business = Datascience.Yelp.Business.new([name: "Pizza Planet"])
      assert business.name == "Pizza Planet"
    end
  end
end
