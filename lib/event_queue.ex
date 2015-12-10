defmodule EventQueue do

  def new, do: HeapQueue.new

  def push(queue, priority, value) do
    HeapQueue.push(queue, priority, value)
  end

  def pop(queue) do
    HeapQueue.pop(queue)
  end

  def remove_with_arc(queue, arc) do
    remove(queue, arc, &has_arc/2)
  end

  def remove(queue, event_to_remove, comparator \\ &is_match/2 ) do
    _remove_any(EventQueue.pop(queue), event_to_remove, comparator, EventQueue.new)
  end

  defp _remove_any({:empty, _}, _, _, new_queue) do
    new_queue
  end

  defp _remove_any({{:value, priority, event}, queue}, event_to_remove, comparator, new_queue) do

    cond do
      comparator.(event, event_to_remove)  ->
        _remove_any(EventQueue.pop(queue), event_to_remove, comparator, new_queue)
      true ->
        _remove_any(EventQueue.pop(queue), event_to_remove, comparator, EventQueue.push(new_queue, priority, event))
    end

  end

  defp is_match(event, event_to_match) do
      event == event_to_match
  end


  defp has_arc([arc_a, arc_b, arc_c], arc) do
    cond do
      arc_a == arc -> true
      arc_b == arc -> true
      arc_c == arc -> true
      true -> false
    end
  end

  defp has_arc(_, arc) do
    false
  end

  def to_list(queue) do
    HeapQueue.to_list(queue)
  end

end
