defmodule BankApiWeb.UserAuth do
  @moduledoc """
  Authenticate requests as user
  """

  import BankApi.Factory
  import Plug.Conn

  def authenticate(conn, user \\ insert(:user)) do
    {:ok, token, _} = BankApiWeb.Guardian.encode_and_sign(user)

    conn
    |> put_req_header("authorization", "Bearer " <> token)
  end
end
