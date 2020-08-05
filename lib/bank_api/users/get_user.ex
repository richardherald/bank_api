defmodule BankApi.Users.GetUser do
  @moduledoc """
  SignIn module
  """
  alias BankApi.Repo
  alias BankApi.Users.Schema.User

  def run(id), do: Repo.get(User, id) |> Repo.preload(:accounts)
end
