defmodule SjcWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: SjcWeb
      import Plug.Conn
      import SjcWeb.Router.Helpers
      import SjcWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/sjc_web/templates",
        namespace: SjcWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      import SjcWeb.Router.Helpers
      import SjcWeb.ErrorHelpers
      import SjcWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import SjcWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
