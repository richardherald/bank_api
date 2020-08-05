defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller

  alias BankApi.Users.{SignIn}
  alias BankApiWeb.Guardian

  action_fallback BankApiWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- SignIn.run(email, password) do
      {:ok, token, _} = Guardian.encode_and_sign(user)
      render(conn, "sign_in.json", %{token: token})
    end
  end
end
