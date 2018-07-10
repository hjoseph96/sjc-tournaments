defmodule SjcWeb.GameChannel do
  @moduledoc """
  Top module to manage connections to the game channel through the websocket.
  """

  use Phoenix.Channel


  alias Sjc.Game

  # TODO: Don't create a game, instead check for 'create_game' messages
  # and create OR join the player to an existing game.
  def join("game:" <> _game_name, _message, socket) do
    {:ok, socket}
  end

  def handle_in("next_round", %{}, socket) do
    broadcast!(socket, "next_round", %{})

    {:noreply, socket}
  end

  def handle_in("time_left", %{"game" => game_name}, socket) do
    time = Game.time_of_round_left(game_name)
    push(socket, "time_left", %{time: time})

    {:noreply, socket}
  end
end