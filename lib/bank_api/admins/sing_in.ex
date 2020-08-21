defmodule BankApi.Admins.SignIn do
  @moduledoc """
  SignIn Admin module
  """

  alias BankApi.Admins.Schema.Admin
  alias BankApi.Repo

  @doc """
  logging into the system as admin

  ## Parameters

    * `email` - String email of the login
    * `password` - String password of the login

  ## Examples

      iex> run("admin@gmail.com", "123456")
      {:ok, token}

      iex> run("admin1@gmail.com", "123456")
      {:error, :username_password_invalid}
  """
  def run(email, password) do
    case Repo.get_by(Admin, email: email) do
      %Admin{} = admin -> verify_password(admin, password)
      nil -> {:error, :username_password_invalid}
    end
  end

  defp verify_password(admin, password) do
    if Argon2.verify_pass(password, admin.password_hash) do
      {:ok, admin}
    else
      {:error, :username_password_invalid}
    end
  end
end
