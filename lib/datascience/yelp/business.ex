defmodule Datascience.Yelp.Business do
#   {
#     "business_id": "1SWheh84yJXfytovILXOAQ",
#     "name": "Arizona Biltmore Golf Club",
#     "address": "2818 E Camino Acequia Drive",
#     "city": "Phoenix",
#     "state": "AZ",
#     "postal_code": "85016",
#     "latitude": 33.5221425,
#     "longitude": -112.0184807,
#     "stars": 3.0,
#     "review_count": 5,
#     "is_open": 0,
#     "attributes": {
#         "GoodForKids": "False"
#     },
#     "categories": "Golf, Active Life",
#     "hours": null
# }

  defstruct(
    business_id: "",
    name: "",
    categories: ""
  )

  def new(fields \\ []), do: __struct__(fields)

end
