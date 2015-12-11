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

  test "we can filter out any tripe of arcs that matches a given arc" do
    old_queue = EventQueue.new
      |> EventQueue.push(1, ["a", %Point{ x: 5, y: 8}, "c"])
      |> EventQueue.push(2, "some other thing")
      |> EventQueue.push(3, ["not", "our", "triple"])

    new_queue = EventQueue.new
      |> EventQueue.push(2, "some other thing")
      |> EventQueue.push(3, ["not", "our", "triple"])

    assert old_queue
      |> EventQueue.remove_with_arc(%Point{ x: 5, y: 8})
      |> EventQueue.to_list == EventQueue.to_list(new_queue)
  end

  test "remove idempotent if not an arc  match" do
      old_queue = EventQueue.new
      |> EventQueue.push(1, ["a", "b", "c"])
      |> EventQueue.push(2, %Point{ x: 5, y: 8})
      |> EventQueue.push(3, ["not", "our", "triple"])

      assert old_queue
      |> EventQueue.remove_with_arc(%Point{ x: 5, y: 8})
      |> EventQueue.to_list == EventQueue.to_list(old_queue)
  end

  test "remove idempotent if no match" do
      old_queue = EventQueue.new
      |> EventQueue.push(1, ["a", "b", "c"])
      |> EventQueue.push(2, "some other thing")
      |> EventQueue.push(3, ["not", "our", "triple"])

      assert old_queue
      |> EventQueue.remove("globnard")
      |> EventQueue.to_list == EventQueue.to_list(old_queue)
  end

end
