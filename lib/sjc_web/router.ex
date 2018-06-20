defmodule SjcWeb.Router do
  use SjcWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SjcWeb do
    pipe_through :api
  end

  scope "/" do
    pipe_through :api

    forward "/graph", Absinthe.Plug.GraphiQL,
      schema: SjcWeb.Schema,
      interface: :simple,
      context: %{pubsub: SjcWeb.Endpoint}
  end
end
