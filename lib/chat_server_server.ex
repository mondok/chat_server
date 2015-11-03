defmodule ChatServer.Server do
  @name     :server

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    IO.puts "Starting server with pid #{inspect pid} on host #{Node.self}"
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def send_message(body) do
    send :global.whereis_name(@name), { :message, body }
  end

  def generator(clients) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator([pid|clients])

      { :message, content} ->
        clients
          |> Enum.each(&(send &1, { :message, content }))
        generator(clients)
    end
  end
end
