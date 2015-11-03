defmodule ChatServer.Client do
  def start(nickname) do
    start_with_host nickname, Application.get_env(:chat_server, :node_host)
  end

  def start_with_host(_, nil), do: IO.puts "No host specified"

  def start_with_host(nickname, host) do
    Node.connect(String.to_atom(host))
    receive do
    after
      2000 ->
        Agent.start_link(fn -> Map.new end, name: __MODULE__)
        set_name(nickname)
        pid = spawn(__MODULE__, :receiver, [])
        ChatServer.Server.register(pid)
    end
  end

  def set_name(nickname) do
    Agent.update(__MODULE__, &Map.put(&1, :name, nickname))
  end

  def get_name do
    Agent.get(__MODULE__, fn map ->
      map[:name]
    end)
  end

  def send_message(content) do
    nickname = get_name
    ChatServer.Server.send_message("#{nickname} > #{content}")
  end

  def receiver do
    receive do
      { :message, content } ->
        IO.puts content
        receiver
    end
  end
end
