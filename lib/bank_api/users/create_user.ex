defmodule BankApi.Users.CreateUser do
  @moduledoc """
  CreateUser module
  """

  alias BankApi.Repo
  alias BankApi.Users.Schema.{Account, User}

  @doc """
  Creating a new user

  ## Parameters

    * `email` - String email of the user
    * `name` - String name of the user
    * `password` - String password of the user
    * `password_confirmation` - String password_confirmation of the user

  ## Examples

      iex> CreateUser.run(%{email: "user@gmail.com", name: "user", password: "123456", password_confirmation: "123456"})
      {:ok, %User{}, %Account{}}

      iex> CreateUser.run(%{email: "", name: "user", password: "123456", password_confirmation: "123456"})
      {:error, %Ecto.Changeset{}}
  """
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

  @doc false
  defp validate_user(params) do
    %User{}
    |> User.changeset(params)
  end

  @doc false
  defp validate_account(user) do
    user
    |> Ecto.build_assoc(:accounts)
    |> Account.changeset()
  end
end
