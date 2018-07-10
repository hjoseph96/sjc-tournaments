defmodule SjcWeb.GameSocket do
  @moduledoc false

  use Phoenix.Socket

  ## Channels
  # channel "room:*", SjcWeb.RoomChannel
  channel "game:*", SjcWeb.GameChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"jwt_token" => token}, socket) do
    # :max_age would make this token valid only for a connection.
    case Phoenix.Token.verify(socket, "ws salt", token, max_age: 20) do
      {:ok, [id, _ip, _timestamp]} ->
        new_socket = assign(socket, :identifier, id)
        {:ok, new_socket}

      {:error, _} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     SjcWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
