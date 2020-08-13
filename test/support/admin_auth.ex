defmodule BankApiWeb.AdminAuth do
  @moduledoc """
  Authenticate requests as admin
  """

  import BankApi.Factory
  import Plug.Conn

  def authenticate(conn, user \\ insert(:user)) do
    {:ok, token, _} = BankApiWeb.GuardianAdmin.encode_and_sign(user)

    conn
    |> put_req_header("authorization", "Bearer " <> token)
  end
end
