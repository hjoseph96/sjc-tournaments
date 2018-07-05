defmodule SjcWeb.GameChannelTest do
  @moduledoc false

  use SjcWeb.ChannelCase

  alias SjcWeb.GameChannel

  setup do
    {:ok, _, socket} = subscribe_and_join(socket(), GameChannel, "game:first")

    {:ok, socket: socket}
  end

  # test "creates game when joined", %{socket: socket} do
  #   IO.inspect socket
  # end

  # test "stops a game when its over", %{socket: socket} do
  #   pid = socket.assigns.game_pid

  #   # Ensure the game process is still running.
  #   assert Process.alive?(pid)

  #   # Stop the game.
  #   ref = push socket, "stop_game", %{"game" => "first"}

  #   assert_reply ref, :ok, %{"stopped" => proc_pid}
  #   assert is_pid(proc_pid)
  #   refute Process.alive?(proc_pid)
  # end
end