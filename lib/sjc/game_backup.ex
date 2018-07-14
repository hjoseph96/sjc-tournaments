defmodule Sjc.GameBackup do
  @moduledoc """
  Keeps the state of a crashed process
  """

  use GenServer

  def start_link(state) do
    GenServer.start(__MODULE__, state, name: via(state.name))
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
    {:noreply, state, timeout()}
  end

  def handle_call(:recover, _from, state) do
    {:reply, state, state, timeout()}
  end

  def handle_info(:timeout, state), do: {:stop, :normal, state}

  defp timeout do
    Application.fetch_env!(:sjc, :game_timeout)
  end
end