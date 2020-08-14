defmodule BankApi.Admins.AdminRepo do
  @moduledoc """
  User repository
  """

  alias BankApi.Admins.Schema.Admin
  alias BankApi.Repo

  def get_admin!(id) do
    Repo.get!(Admin, id)
  end
end
