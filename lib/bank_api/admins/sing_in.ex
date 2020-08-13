defmodule BankApi.Admins.SignIn do
  @moduledoc """
  SignIn module
  """

  alias BankApi.Admins.Schema.Admin
  alias BankApi.Repo

  def run(email, password) do
    case Repo.get_by(Admin, email: email) do
      %Admin{} = admin -> verify_password(admin, password)
      nil -> {:error, "username or password invalid"}
    end
  end

  defp verify_password(admin, password) do
    if Bcrypt.verify_pass(password, admin.password_hash) do
      {:ok, admin}
    else
      {:error, "username or password invalid"}
    end
  end
end
