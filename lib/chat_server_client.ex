# c("lib/chatter.ex")
# Node.connect :"one@mmondok-ltm"
# killall -9 beam.smp

defmodule ChatServer.Client do
  def start(nickname) do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)

    set_name(nickname)
    pid = spawn(__MODULE__, :receiver, [])

    ChatServer.Server.register(pid)
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
