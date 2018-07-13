defmodule Sjc.GameBackup do
  @moduledoc """
  Keeps the state of a crashed process
  """

  use GenServer

  def start_link(name) do
    # We initialize the process with the same state as main Game process.
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

  def save_state(name, state) do
    GenServer.cast(via(name), {:save, state})
  end

  def recover_state(name) do
    GenServer.call(via(name), :recover)
  end

  defp via(name) do
    {:via, Registry, {:game_backup, name}}
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:save, state}, _state) do
    {:noreply, state}
  end

  def handle_call(:recover, _from, state) do
    {:reply, state, state}
  end
end