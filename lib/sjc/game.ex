defmodule Sjc.Game do
  @moduledoc """
  Top level Module to manage games.
  """

  use GenServer

  require Logger

  alias Sjc.Game.Player

  # API

  # TODO: Check what can stay in the process and what should be in the database
  # we can pull a reference and just use the information from the database in the process
  def start_link(name) do
    state = %{
      round: %{
        number: 1
      },
      players: [],
      actions: [],
      special_rules: %{
        care_package: 2
      },
      name: name
    }

    GenServer.start_link(__MODULE__, state, name: via(name))
  end

  def next_round(name) do
    GenServer.cast(via(name), :next_round)
  end

  def state(name) do
    GenServer.call(via(name), :state)
  end

  def add_player(name, attributes) do
    GenServer.call(via(name), {:add_player, attributes})
  end

  # Register new processes per lobby, identified by 'name'.
  defp via(name) do
    {:via, Registry, {:game_registry, name}}
  end

  # Server

  def init(state) do
    {:ok, state, timeout()}
  end

  def terminate(:normal, _state), do: :ok
  def terminate(reason, state), do: {reason, state}

  def handle_cast(:next_round, %{round: %{number: round_num}, name: name} = state) do
    # TODO: Add small health regen for everyone still alive

    new_round = round_num + 1
    # Each N amount of rounds (Specified in state), drop a 'care package'.
    case rem(new_round, state.special_rules.care_package) do
      0 -> Process.send(get_pid(name), :care_package, [:nosuspend])
      _ -> :ok
    end

    {:noreply, put_in(state.round.number, new_round), timeout()}
  end

  # Returns the whole process state
  def handle_call(:state, _from, state) do
    {:reply, state, state, timeout()}
  end

  # Adds player if it doesn't exist yet.
  def handle_call({:add_player, attrs}, _from, state) do
    player = struct(Player, attrs)

    case Enum.any?(state.players, & &1.id == attrs.id) do
      true -> {:reply, {:error, :already_added}, state, timeout()}
      false -> {:reply, {:ok, :added}, update_in(state, [:players], &List.insert_at(&1, -1, player)), timeout()}
    end
  end

  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  def handle_info(:care_package, state) do
    # TODO: Implementation
    Logger.debug("[RECEIVED] CARE PACKAGE FROM #{state.name}")

    {:noreply, state}
  end

  # Timeout is just the time a GenServer (Lobby process) can stay alive without
  # receiving any messages, defaults to 1 hour.
  # 1 hour without receiving any messages = die.
  defp timeout do
    Application.fetch_env!(:sjc, :game_timeout)
  end

  def get_pid(name) do
    [{pid, _}] = Registry.lookup(:game_registry, name)
    pid
  end
end
