defmodule SjcWeb.Router do
  use SjcWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/v1" do
    pipe_through(:api)

    forward("/", Absinthe.Plug, schema: SjcWeb.Schema)
  end

  forward(
    "/graph",
    Absinthe.Plug.GraphiQL,
    schema: SjcWeb.Schema,
    interface: :simple,
    context: %{pubsub: SjcWeb.Endpoint}
  )
end
