defmodule BankApi.Users.AccountRepo do
  @moduledoc """
  Account repository
  """

  alias BankApi.Repo
  alias BankApi.Users.Schema.Account

  def get_account(id) do
    Repo.get(Account, id)
  end
end
