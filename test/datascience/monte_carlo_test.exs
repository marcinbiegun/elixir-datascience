defmodule Datascience.MonteCarloTest do
  use ExUnit.Case
  alias Datascience.MonteCarlo

  describe "add_text/2" do
      data = MonteCarlo.add_text("My name is Bob.")

      assert data == %{
        :start => %{"my" => 1},
        "my" => %{"name" => 1},
        "name" => %{"is" => 1},
        "is" => %{"bob" => 1},
        "bob" => %{:end => 1}
      }
  end

  describe "add_pair/2" do
    test "adding data" do
      data = %{}
      |> MonteCarlo.add_pair(:start, "My")
      |> MonteCarlo.add_pair("My", "name")
      |> MonteCarlo.add_pair("name", "is")
      |> MonteCarlo.add_pair("is", "Bob")
      |> MonteCarlo.add_pair("is", "Ann")
      |> MonteCarlo.add_pair("Bob", :end)
      |> MonteCarlo.add_pair("Ann", :end)

      assert data == %{
        :start => %{"My" => 1},
        "Ann" => %{end: 1},
        "Bob" => %{end: 1},
        "My" => %{"name" => 1},
        "is" => %{"Ann" => 1, "Bob" => 1},
        "name" => %{"is" => 1}
      }

      #IO.inspect data
      #transposed_data = MonteCarlo.transpose(data)
      #    IO.inspect transposed_data
      # result = MonteCarlo.generate(data)
      # IO.puts result
    end
  end
end
