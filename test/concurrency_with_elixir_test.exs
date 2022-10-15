defmodule ConcurrencyWithElixirTest do
  use ExUnit.Case
  doctest ConcurrencyWithElixir

  test "greets the world" do
    assert ConcurrencyWithElixir.hello() == :world
  end
end
