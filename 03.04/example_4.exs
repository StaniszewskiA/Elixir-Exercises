for proc <- [A, B, C] do
  proc
  |> Process.whereis()
  |> (fn
        nil -> :ok
        pid -> Process.exit(pid, :kill)
    end).()
end

IO.inspect(self(), label: "I am")

a =
  spawn(fn ->
    Process.register(self(), A)
    IO.inspect({A, self()}, label: "I am")

    receive do
      :crash -> 1 = 2
      :die_normally -> :ok
    end
  end)

Process.sleep(1000)

b =
  spawn(fn ->
    Process.register(self(), B)
    IO.inspect({B, self()}, label: "I am")

    A
    |> Process.whereis()
    |> Process.link()

    receive do
      _ -> :ok
    end
  end)

Process.sleep(1000)

send(A, :crash)

Process.sleep(1000)

IO.inspect(:erlang.process_info(a), label: "Final A info")
IO.inspect(:erlang.process_info(b), label: "Final B info")

for proc <- [A, B] do
  proc
  |> Process.whereis()
  |> (fn
        nil -> :ok
        pid -> Process.exit(pid, :kill)
      end).()
end
