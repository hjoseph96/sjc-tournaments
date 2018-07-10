defmodule SjcWeb.AuthResolver do
  @moduledoc false

  # TODO: Check if the three items in 'identifier' are really necessary.
  # We're expecting ID, IP and Timestamp as a list in 'identifier'.
  def get_auth(_root, %{identifier: identifier}, _res) when is_list(identifier) do
    # The token generated here is the one that should be used for the
    # channel connection.
    token = Phoenix.Token.sign(SjcWeb.Endpoint, "ws salt", identifier)

    {:ok, %{token: token}}
  end

  def get_auth(_root, _args, _res), do: {:error, "missing identifier"}
end