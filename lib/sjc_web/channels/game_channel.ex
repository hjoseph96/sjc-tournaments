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

  def handle_in("stop_game", %{"game" => game_identifier}, socket) do
    # This function returns the pid of the stopped process.
    pid = GameSupervisor.stop_child(game_identifier)

    {:reply, {:ok, %{"stopped" => pid}}, socket}
  end
end