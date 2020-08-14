defmodule BankApiWeb.AdminAuth do
  @moduledoc """
  Authenticate requests as admin
  """

  import BankApi.Factory
  import Plug.Conn

  def authenticate(conn, admin \\ insert(:admin)) do
    {:ok, token, _} = BankApiWeb.GuardianAdmin.encode_and_sign(admin)

    conn
    |> put_req_header("authorization", "Bearer " <> token)
  end
end
