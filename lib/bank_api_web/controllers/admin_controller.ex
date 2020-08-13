defmodule BankApiWeb.AdminController do
  use BankApiWeb, :controller

  alias BankApi.Admins.Schema.Admin
  alias BankApi.Admins.CreateAdmin
  alias BankApiWeb.Guardian

  action_fallback BankApiWeb.FallbackController

  def sign_up(conn, params) do
    with {:ok, admin} <- CreateAdmin.run(params) do
      conn
      |> put_status(:created)
      |> render("sign_up.json", %{admin: admin})
    end
  end
end
