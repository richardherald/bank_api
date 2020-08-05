defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller

  alias BankApi.Users.{SignIn}

  action_fallback BankApiWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- SignIn.run(email, password) do
      conn
      |> render("sign_in.json", %{user: user})
    end
  end
end
