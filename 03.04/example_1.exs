self()

self() |> :erlang.process_info()

IO.inspect(self(), label: "I'm parent process")
spawn(fn -> IO.inspect(self(), label: "I'm child process") end)

defmodule PidPrinter do
  def print_my_pid, do: IO.inspect(self(), label: "I'm child process")
  def print_my_pid(extra), do: IO.inspect({self(), extra}, label: "I'm child process")
end

IO.inspect(self(), label: "I'm parent process")
spawn(&PidPrinter.print_my_pid/0)
spawn(PidPrinter, :print_my_pid, ["XD"])

send(self(), "Hello")

receive do
  msg -> IO.inspect(msg, label: "I've received")
end

flush_fun = fn fun ->
  receive do
    msg ->
      IO.inspect(msg)
      fun.(fun)
  after
    0 ->
      IO.inspect("Flushing is done")
      :ok
  end
end

flush_fun.(flush_fun)

send(self(), {:question, "How are you"})

receive do
  {:greetings, content} -> IO.inspect(content, label: "I've received")
after
  5000 -> IO.inspect(:timeout, label: "I've received")
end

sleep_fun = fn time ->
  receive do
  after
    time -> :ok
  end
end

sleep_fun.(3000)

send(self(), {:question, "How are you?"})
Process.sleep(5000)
send(self(), {:greetings, "Hello"})

receive do
  {:question, question} ->
    IO.inspect(question, label: "I've received")
end

spawn(fn ->
  Process.register(self(), :krzys)

  receive do
    msg -> IO.inspect(msg, label: "Krzys received")
  end
end)

Proces.sleep(1000)

send(:krzys, "Hello")
