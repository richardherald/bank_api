defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller

  alias BankApi.Users.Schema.User
  alias BankApi.Users.{CreateUser, GetUser, SignIn}
  alias BankApiWeb.GuardianUser

  action_fallback BankApiWeb.FallbackController

  def sign_up(conn, params) do
    with {:ok, user, account} <- CreateUser.run(params) do
      conn
      |> put_status(:created)
      |> render("sign_up.json", %{user: user, account: account})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- SignIn.run(email, password) do
      {:ok, token, _} = GuardianUser.encode_and_sign(user)
      render(conn, "sign_in.json", %{token: token})
    end
  end

  def get_user(conn, %{"id" => id}) do
    with %User{} = user <- GetUser.run(id) do
      conn
      |> render("get_user.json", user: user)
    end
  end
end
