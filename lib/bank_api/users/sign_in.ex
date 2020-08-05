defmodule BankApi.Users.SignIn do
  @moduledoc """
  SignIn module
  """

  alias BankApi.Repo
  alias BankApi.Users.Schema.User

  def run(email, password) do
    case Repo.get_by(User, email: email) do
      %User{} = user -> verify_password(user, password)
      nil -> {:error, "username or password invalid"}
    end
  end

  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "username or password invalid"}
    end
  end
end
