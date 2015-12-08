defmodule EventQueueTest do
  use ExUnit.Case
  doctest EventQueue

  test "we can filter out indicated tripes" do

    old_queue = EventQueue.new
      |> EventQueue.push(1, ["a", "b", "c"])
      |> EventQueue.push(2, "some other thing")
      |> EventQueue.push(3, ["not", "our", "triple"])

    new_queue = EventQueue.new
      |> EventQueue.push(2, "some other thing")
      |> EventQueue.push(3, ["not", "our", "triple"])

    assert old_queue
      |> EventQueue.remove(["a", "b", "c"])
      |> EventQueue.to_list == EventQueue.to_list(new_queue)
  end

  test "idempotent if no match" do
      old_queue = EventQueue.new
      |> EventQueue.push(1, ["a", "b", "c"])
      |> EventQueue.push(2, "some other thing")
      |> EventQueue.push(3, ["not", "our", "triple"])

      assert old_queue
      |> EventQueue.remove("globnard")
      |> EventQueue.to_list == EventQueue.to_list(old_queue)
  end

end
