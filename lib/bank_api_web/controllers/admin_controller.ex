defmodule BankApiWeb.AdminController do
  use BankApiWeb, :controller

  alias BankApi.Admins.{CreateAdmin, SignIn}
  alias BankApiWeb.Guardian

  action_fallback BankApiWeb.FallbackController

  def sign_up(conn, params) do
    with {:ok, admin} <- CreateAdmin.run(params) do
      conn
      |> put_status(:created)
      |> render("sign_up.json", %{admin: admin})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, admin} <- SignIn.run(email, password) do
      {:ok, token, _} = Guardian.encode_and_sign(admin)
      render(conn, "sign_in.json", %{token: token})
    end
  end
end
