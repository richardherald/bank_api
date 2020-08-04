defmodule BankApi.Users.CreateUser do
  @moduledoc """
  Creating a new user
  """

  alias BankApi.Repo
  alias BankApi.Users.Schema.{Account, User}

  def run(params) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user, validate_user(params))
      |> Ecto.Multi.insert(:account, fn %{user: user} ->
        validate_account(user)
      end)

    case Repo.transaction(multi) do
      {:ok, result} -> {:ok, result.user, result.account}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  defp validate_user(params) do
    %User{}
    |> User.changeset(params)
  end

  defp validate_account(user) do
    user
    |> Ecto.build_assoc(:accounts)
    |> Account.changeset()
  end
end
