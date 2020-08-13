defmodule BankApi.Admins.CreateAdmin do
  @moduledoc """
  Creating a new admin
  """

  alias BankApi.Repo
  alias BankApi.Admins.Schema.Admin

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
