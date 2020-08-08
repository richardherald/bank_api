defmodule BankApi.Users.UserRepo do
  @moduledoc """
  User repository
  """

  alias BankApi.Repo
  alias BankApi.Users.Schema.User

  def get_user!(id) do
    Repo.get!(User, id) |> Repo.preload(:accounts)
  end
end
