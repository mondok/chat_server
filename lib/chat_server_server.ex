defmodule ChatServer.Server do
  use GenServer
  @name     :server

  def start_link do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
    IO.puts "Starting server"

    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # def handle_cast({:register, client_pid})

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
