defmodule SjcWeb.GameChannel do
  @moduledoc """
  Top module to manage connections to the game channel through the websocket.
  """

  use Phoenix.Channel

  alias Sjc.Supervisors.GameSupervisor

  # TODO: Don't create a game, instead check for 'create_game' messages
  # and create OR join the player to an existing game.
  def join("game:" <> game_name, _message, socket) do
    {:ok, pid} = GameSupervisor.start_child(game_name)

    {:ok, assign(socket, :game_pid, pid)}
  end
end