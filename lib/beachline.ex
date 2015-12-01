defmodule Beachline do

  def new do
    RedBlackTree.new([], comparator: fn (node1, node2) ->
      cond do
        node1.site.x < node2.site.x -> -1
        node1.site.x > node2.site.x -> 1
        true -> 0
      end
    end)
  end

  def insert do
    RedBlackTree.insert
  end
end
