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

Process.sleep(100)

b =
  spawn(fn ->
    Process.register(self(), B)
    Process.flag(:trap_exit, true)
    IO.inspect({B, self()}, label: "I am")

    A
    |> Process.whereis()
    |> Process.link()

    receive do
      msg -> IO.inspect(msg, label: "The trap exit message")
    end

    receive do
      _ -> :ok
    end
  end)

Process.sleep(100)

send(A, :crash)

Process.sleep(100)

IO.inspect(:erlang.process_info(a), label: "Final A info")
IO.inspect(:erlang.process_info(b), label: "Final B info")
