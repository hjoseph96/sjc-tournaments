defmodule Sjc.Supervisors.GameSupervisor do
  @moduledoc """
  Module in charge of initializing game processes.
  """

  # Note: we're using the old specification because of Phoenix, this is deprecated in newer
  # Elixir versions.

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(name) do
    pid =
      case Supervisor.start_child(__MODULE__, [name]) do
        {:ok, pid} -> pid
        {:error, {_reason, pid}} -> pid
      end

    {:ok, pid}
  end

  def stop_child(name) do
    pid = get_pid(name)
    Supervisor.terminate_child(__MODULE__, pid)
  end

  def init(arg) do
    children = [
      worker(Sjc.Game, arg, restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  # Get the pid of the process from the Registry so we can terminate it.
  defp get_pid(name) do
    [{pid, _nil}] = Registry.lookup(:game_registry, name)
    pid
  end
end
