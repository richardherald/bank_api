defmodule BankApi.Users.AdminRepo do
  @moduledoc """
  User repository
  """

  alias BankApi.Repo
  alias BankApi.Users.Schema.Admin

  def get_admin!(id) do
    Repo.get!(Admin, id)
  end
end
