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
      name: name,
      shift_automatically: true,
      time_of_round: Timex.now()
    }

    GenServer.start_link(__MODULE__, state, name: via(name))
  end

  def next_round(name) do
    GenServer.cast(via(name), :next_round)
  end

  def remove_player(name, identifier) do
    GenServer.cast(via(name), {:remove_player, identifier})
  end

  def state(name) do
    GenServer.call(via(name), :state)
  end

  def add_player(name, attributes) do
    GenServer.call(via(name), {:add_player, attributes})
  end

  def shift_automatically(name) do
    GenServer.call(via(name), :shift_automatically)
  end

  def time_of_round_left(name) do
    GenServer.call(via(name), :time_of_round_left)
  end

  # Register new processes per lobby, identified by 'name'.
  defp via(name) do
    {:via, Registry, {:game_registry, name}}
  end

  # Server

  def init(state) do
    schedule_round_timeout(state.name)

    {:ok, state, timeout()}
  end

  defp schedule_round_timeout(name) do
    Process.send_after(get_pid(name), :round_timeout, round_timeout())
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

    # We send a signal to the channel because a round has just passed
    SjcWeb.Endpoint.broadcast("game:" <> name, "next_round", %{})

    new_state =
      state
      |> put_in([:round, :number], new_round)
      |> put_in([:time_of_round], Timex.now())

    {:noreply, new_state, timeout()}
  end

  def handle_cast({:remove_player, identifier}, state) do
    players = Enum.reject(state.players, & &1.id == identifier)

    {:noreply, put_in(state.players, players), timeout()}
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

  # When testing or when we don't want to automatically shift rounds we call this function.
  # @dev what happens here is that when you a specific process then you interrupt the timeout()
  # in each return of a 'handle_*' call, which would make the process to live forever even when
  # not in use. This also makes it impossible to test if a process dies within the specified time
  # in timeout/0
  def handle_call(:shift_automatically, _from, state) do
    # If true, make it false, true otherwise.
    will_shift? = !state.shift_automatically

    {:reply, will_shift?, %{state | shift_automatically: will_shift?}}
  end

  def handle_call(:time_of_round_left, _from, state) do
    remaining = Timex.diff(Timex.now(), state.time_of_round, :seconds)

    {:reply, remaining, state}
  end

  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  def handle_info(:care_package, state) do
    # TODO: Implementation
    Logger.debug("[RECEIVED] CARE PACKAGE FROM " <> state.name)

    {:noreply, state, timeout()}
  end

  def handle_info(:round_timeout, state) do
    # We schedule the round timeout here so the 'handle_cast/2' function doesn't call
    # 'Process.send_after/3' when the function is called manually.
    if state.shift_automatically, do: schedule_round_timeout(state.name)

    handle_cast(:next_round, state)
  end

  # Timeout is just the time a GenServer (Lobby process) can stay alive without
  # receiving any messages, defaults to 1 hour.
  # 1 hour without receiving any messages = die.
  defp timeout do
    Application.fetch_env!(:sjc, :game_timeout)
  end

  defp round_timeout do
    Application.fetch_env!(:sjc, :round_timeout)
  end

  def get_pid(name) do
    [{pid, _}] = Registry.lookup(:game_registry, name)
    pid
  end
end
