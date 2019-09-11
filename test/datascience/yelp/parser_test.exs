defmodule Datascience.Yelp.ParserTest do
  use ExUnit.Case
  alias Datascience.Yelp.Parser

  describe "new/1" do
    test "creates new struct from json string" do
      json = ~s({"business_id":"1SWheh84yJXfytovILXOAQ","name":"Arizona Biltmore Golf Club","address":"2818 E Camino Acequia Drive","city":"Phoenix","state":"AZ","postal_code":"85016","latitude":33.5221425,"longitude":-112.0184807,"stars":3.0,"review_count":5,"is_open":0,"attributes":{"GoodForKids":"False"},"categories":"Golf, Active Life","hours":null})
      business = Parser.business(json)

      assert business.business_id == "1SWheh84yJXfytovILXOAQ"
      assert business.name == "Arizona Biltmore Golf Club"
      assert business.categories == ["Golf", "Active Life"]
    end
  end
end
