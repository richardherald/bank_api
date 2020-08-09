defmodule BankApi.Operations.Withdraw do
  @moduledoc """
  Transfer module
  """

  alias BankApi.Repo
  alias BankApi.Users.AccountRepo
  alias BankApi.Users.Schema.Account

  def run(from_id, value) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.run(:is_negative_balance, fn _, _ ->
        case is_negative_balance?(value) do
          true -> {:error, :negative_balance}
          false -> {:ok, false}
        end
      end)
      |> Ecto.Multi.run(:account_from, fn _, _ -> get_account(from_id) end)
      |> Ecto.Multi.run(:is_insufficient_negative, fn _, %{account_from: account_from} ->
        case is_insufficient_balance?(account_from.balance, value) do
          true -> {:error, :insufficient_funds}
          false -> {:ok, false}
        end
      end)
      |> Ecto.Multi.update(:from, fn %{account_from: account_from} ->
        operation(account_from, value, :sub)
      end)

    case Repo.transaction(multi) do
      {:ok, %{from: from}} -> {:ok, from}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  def get_account(id) do
    case AccountRepo.get_account(id) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  def is_negative_balance?(value) do
    Decimal.new(value) |> Decimal.negative?()
  end

  def is_insufficient_balance?(from_value, value) do
    Decimal.sub(from_value, value) |> Decimal.negative?()
  end

  def operation(account, value, :sub) do
    account
    |> Account.changeset(%{balance: Decimal.sub(account.balance, value) |> Decimal.to_integer()})
  end
end
