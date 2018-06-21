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
    Supervisor.start_child(__MODULE__, [name])
  end

  def init(arg) do
    children = [
      worker(Sjc.Game, arg)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
