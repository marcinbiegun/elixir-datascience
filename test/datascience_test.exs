defmodule DatascienceTest do
  use ExUnit.Case
  doctest Datascience

  test "greets the world" do
    assert Datascience.hello() == :world
  end
end
