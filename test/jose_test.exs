defmodule JoseTest do
  use ExUnit.Case
  doctest Jose

  test "greets the world" do
    assert Jose.hello() == :world
  end
end
