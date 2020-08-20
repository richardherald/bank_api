defmodule BankApi.Admins.CreateAdmin do
  @moduledoc """
  CreateAdmin module
  """

  alias BankApi.Admins.Schema.Admin
  alias BankApi.Repo

  @doc """
  Creating a new Admin

  ## Parameters

    * `email` - String email of the admin
    * `password` - String password of the admin
    * `password_confirmation` - String password_confirmation of the admin

  ## Examples

      iex> run(%{email: "admin@gmail.com", password: "123456", password_confirmation: "123456"})
      {:ok, %Admin{}}

      iex> run(%{email: "", password: "123456", password_confirmation: "123456"})
      {:error, %Ecto.Changeset{}}
  """

  def run(params) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:admin, validate_admin(params))

    case Repo.transaction(multi) do
      {:ok, result} -> {:ok, result.admin}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  defp validate_admin(params) do
    %Admin{}
    |> Admin.changeset(params)
  end
end
