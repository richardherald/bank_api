defmodule BankApi.Users.SignIn do
  @moduledoc """
  SignIn User module
  """

  alias BankApi.Repo
  alias BankApi.Users.Schema.User

  @doc """
  logging into the system as user

  ## Parameters

    * `email` - String email of the login
    * `password` - String password of the login

  ## Examples

      iex> run("user@gmail.com", "123456"})
      {:ok, token}

      iex> run("user@gmail.com", "123456")
      {:error, :username_password_invalid}
  """
  def run(email, password) do
    case Repo.get_by(User, email: email) do
      %User{} = user -> verify_password(user, password)
      nil -> {:error, :username_password_invalid}
    end
  end

  defp verify_password(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :username_password_invalid}
    end
  end
end
