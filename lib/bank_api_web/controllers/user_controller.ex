defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller

  alias BankApi.Users.Schema.User
  alias BankApi.Users.{GetUser, SignIn}
  alias BankApiWeb.Guardian

  action_fallback BankApiWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- SignIn.run(email, password) do
      {:ok, token, _} = Guardian.encode_and_sign(user)
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
