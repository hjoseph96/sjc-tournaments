defmodule Sjc.Game do
  @moduledoc """
  Top level Module to manage games.
  """

  use GenServer

  # API

  # TODO: Check what can stay in the process and what should be in the database
  # we can pull a reference and just use the information from the database in the process
  def start_link(name) do
    state = %{
      round: %{
        number: 1,
        special_rules: []
      },
      players: [],
      actions: []
    }

    GenServer.start_link(__MODULE__, state, name: via(name))
  end

  def next_round(name) do
    GenServer.cast(via(name), :next_round)
  end

  def state(name) do
    GenServer.call(via(name), :state)
  end

  # Register new processes per lobby, identified by 'name'.
  defp via(name) do
    {:via, Registry, {:game_registry, name}}
  end

  # Server

  def init(state) do
    {:ok, state}
  end

  def handle_cast(:next_round, %{round: %{number: round_num}} = state) do
    {:noreply, put_in(state.round.number, round_num + 1)}
  end

  # Returns the whole process state
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
