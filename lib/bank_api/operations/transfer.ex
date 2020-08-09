defmodule BankApi.Operations.Transfer do
  @moduledoc """
  Transfer module
  """

  alias BankApi.Repo
  alias BankApi.Users.AccountRepo
  alias BankApi.Users.Schema.Account

  def run(from_id, to_id, value) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.run(:is_own_account, fn _, _ ->
        case is_own_account?(from_id, to_id) do
          true -> {:error, :transfer_your_own_account}
          false -> {:ok, false}
        end
      end)
      |> Ecto.Multi.run(:is_negative_value, fn _, _ ->
        case is_negative_value?(value) do
          true -> {:error, :negative_value}
          false -> {:ok, false}
        end
      end)
      |> Ecto.Multi.run(:account_from, fn _, _ -> get_account(from_id) end)
      |> Ecto.Multi.run(:is_insufficient_balance, fn _, %{account_from: account_from} ->
        case is_insufficient_balance?(account_from.balance, value) do
          true -> {:error, :insufficient_balance}
          false -> {:ok, false}
        end
      end)
      |> Ecto.Multi.run(:account_to, fn _, _ -> get_account(to_id) end)
      |> Ecto.Multi.update(:from, fn %{account_from: account_from} ->
        operation(account_from, value, :sub)
      end)
      |> Ecto.Multi.update(:to, fn %{account_to: account_to} ->
        operation(account_to, value, :add)
      end)

    case Repo.transaction(multi) do
      {:ok, %{from: from, to: to}} -> {:ok, from, to}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  def get_account(id) do
    case AccountRepo.get_account(id) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  def is_own_account?(from_id, to_id) do
    from_id == to_id
  end

  def is_negative_value?(value) do
    Decimal.new(value) |> Decimal.negative?()
  end

  def is_insufficient_balance?(from_value, value) do
    Decimal.sub(from_value, value) |> Decimal.negative?()
  end

  def operation(account, value, :sub) do
    account
    |> Account.changeset(%{balance: Decimal.sub(account.balance, value) |> Decimal.to_integer()})
  end

  def operation(account, value, :add) do
    account
    |> Account.changeset(%{balance: Decimal.add(account.balance, value) |> Decimal.to_integer()})
  end
end
