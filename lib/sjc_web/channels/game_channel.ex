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

  # Used when the user is already connected to the channel.
  def handle_in("next_round", %{"number" => round_number}, socket) do
    broadcast!(socket, "next_round", %{number: round_number})

    {:noreply, socket}
  end

  def handle_in("in_time_left", %{"game" => game_name}, socket) do
    time = Game.time_of_round_left(game_name)
    push(socket, "out_time_left", %{time: time})

    {:noreply, socket}
  end

  # Used when an user is joining the channel.
  def handle_in("initial_next_round", %{"game" => game_name}, socket) do
    round = Game.state(game_name).round.number
    push(socket, "next_round", %{number: round})

    {:noreply, socket}
  end

  # Each round should have a list or map of actions, Those are added to the
  # Game state and executed before the next rounds begins.
  def handle_in("in_round_actions", %{"actions" => actions, "game" => game_name}, socket) do
    Game.add_round_actions(game_name, actions)

    {:noreply, socket}
  end
end