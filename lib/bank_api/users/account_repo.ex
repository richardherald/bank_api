defmodule BankApi.Users.AccountRepo do
  @moduledoc """
  Account repository
  """

  alias BankApi.Repo
  alias BankApi.Users.Schema.Account

  @doc """
  Gets a single account.

  ## Examples

      iex> get_account("0b386772-7397-45be-9a43-3fb12a617bb7")
      %Account{}

      iex> get_account("0b386772-7397-45be-9a43-3fb12a617111")
      nil
  """
  def get_account(id) do
    Repo.get(Account, id)
  end
end
