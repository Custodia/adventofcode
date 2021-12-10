defmodule AdventOfCode.Year2018.Day07 do
  @filename "../inputs/2018/day07.txt"

  @char_list ?A..?Z |> Enum.into([]) |> List.to_string() |> String.graphemes()

  def part1 do
    File.stream!(@filename)
    |> parse_input()
    |> get_sequential_steps()
    |> Enum.join()
  end

  def part2 do
    task_times = @char_list |> Enum.with_index(61) |> Map.new()
    workers = 5

    File.stream!(@filename)
    |> parse_input()
    |> process_in_parallel(task_times, workers)
  end

  def parse_input(stream) do
    found_prereqs =
      stream
      |> Stream.map(&String.trim/1)
      |> Stream.map(&parse_line/1)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Map.new()

    @char_list
    |> Enum.map(fn c -> {c, Map.get(found_prereqs, c, [])} end)
  end

  def parse_line("Step " <> <<needs::binary-size(1)>> <> " must be finished before step " <> <<step::binary-size(1)>> <>" can begin."), do: {step, needs}

  def get_sequential_steps(steps, result \\ [])
  def get_sequential_steps([], result), do: Enum.reverse(result)
  def get_sequential_steps(steps, result) do
    next_step =
      steps
      |> Enum.find(fn {_, reqs} -> reqs == [] end)
      |> then(&elem(&1, 0))

    remaining_steps =
      steps
      |> Enum.filter(fn {step, _reqs} -> step != next_step end)
      |> Enum.map(fn {step, reqs} -> {step, Enum.filter(reqs, &(&1 != next_step))} end)

    get_sequential_steps(remaining_steps, [next_step | result])
  end

  def process_in_parallel(tasks, task_times, worker_count) do
    tasks_with_times =
      Enum.map(tasks, fn {c, reqs} -> {c, reqs, Map.fetch!(task_times, c)} end)

    worker_queue =
      tasks_with_times
      |> Enum.filter(fn {_c, reqs, _time} -> reqs == [] end)
      |> Enum.map(fn {c, _reqs, time} -> {c, time} end)
      |> Enum.take(worker_count)
    next_tasks = Enum.map(worker_queue, &elem(&1, 0))
    remaining_tasks = Enum.reject(tasks_with_times, fn {c, _, _} -> c in next_tasks end)

    process_in_parallel(remaining_tasks, worker_queue, worker_count, 0)
  end

  defp process_in_parallel([], worker_queue, _worker_count, result) do
    {_, time_taken} = Enum.max_by(worker_queue, &elem(&1, 1))
    result + time_taken
  end
  defp process_in_parallel(tasks, worker_queue, worker_count, result) do
    worker_queue = Enum.sort_by(worker_queue, &elem(&1, 1))
    {_, time_taken} = List.first(worker_queue)

    {finished_tasks, remaining_queue} = Enum.split_while(worker_queue, &(elem(&1, 1) == time_taken))

    finished_tasks = Enum.map(finished_tasks, &elem(&1, 0))
    remaining_queue = Enum.map(remaining_queue, fn {c, time} -> {c, time - time_taken} end)
    tasks = Enum.map(tasks, fn {step, reqs, time} -> {step, Enum.reject(reqs, &(&1 in finished_tasks)), time} end)

    new_worker_queue =
      tasks
      |> Enum.filter(fn {_, reqs, _} -> reqs == [] end)
      |> Enum.map(fn {c, _reqs, time} -> {c, time} end)
      |> Enum.take(worker_count - length(remaining_queue))
      |> Enum.concat(remaining_queue)
    next_tasks = Enum.map(new_worker_queue, &elem(&1, 0))
    remaining_tasks = Enum.reject(tasks, fn {c, _, _} -> c in next_tasks end)

    process_in_parallel(remaining_tasks, new_worker_queue, worker_count, result + time_taken)
  end
end
