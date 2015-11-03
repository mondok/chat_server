# ChatServer

Simple Elixir PoC chat server.

## Running Server
On window 1, run:

```
iex --sname one -S mix
```

Once you're in the console, start the server with:

```
ChatServer.Server.start
```

On window 2, run:
```
HOST="whatever@thehostwas" iex --sname two -S mix
```

Once you're in the console, start a client with:
```
ChatServer.Client.start "some_nickname"
```

Send messages with:
```
ChatServer.Client.send_message "Hello world"
```

Finally, kill any lingering BEAM processes:
```
killall -9 beam.smp
```
