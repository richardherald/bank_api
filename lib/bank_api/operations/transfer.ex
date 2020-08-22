defmodule BankApi.Operations.Transfer do
  @moduledoc """
  Transfer module
  """

  alias BankApi.Repo
  alias BankApi.Transactions.Schema.Transaction
  alias BankApi.Users.AccountRepo
  alias BankApi.Users.Schema.Account

  @withdraw "withdraw"
  @deposit "deposit"

  @doc """
  Transferring money

  ## Parameters

    * `from_id` - String account id sending the money
    * `to_id` - String account id receive the money
    * `value` - Integer transfer amount

  ## Examples

      iex> run("0b386772-7397-45be-9a43-3fb12a617bb7", "0b386772-7397-45be-9a43-3fb12a611111", 100)
      {:ok, %{account_from, account_to}}

      iex> run("0b386772-7397-45be-9a43-3fb12a617bb7", "0b386772-7397-45be-9a43-3fb12a611111", -100)
      {:error, :negative_value}
  """
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
        case is_zero_or_negative_value?(value) do
          true -> {:error, :zero_or_negative_value}
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
      |> Ecto.Multi.update(:update_account_from, fn %{account_from: account_from} ->
        operation(account_from, value, :sub)
      end)
      |> Ecto.Multi.update(:update_account_to, fn %{account_to: account_to} ->
        operation(account_to, value, :add)
      end)
      |> Ecto.Multi.insert(:transaction_from, fn %{account_from: account_from} ->
        validate_transaction(account_from, value, @withdraw)
      end)
      |> Ecto.Multi.insert(:transaction_to, fn %{account_to: account_to} ->
        validate_transaction(account_to, value, @deposit)
      end)
      |> Ecto.Multi.update(
        :transaction_link_from,
        fn %{transaction_from: transaction_from, transaction_to: transaction_to} ->
          validate_transaction_link(transaction_from, transaction_to.id)
        end
      )
      |> Ecto.Multi.update(
        :transaction_link_to,
        fn %{transaction_to: transaction_to, transaction_from: transaction_from} ->
          validate_transaction_link(transaction_to, transaction_from.id)
        end
      )

    case Repo.transaction(multi) do
      {:ok, %{update_account_from: from, update_account_to: to}} -> {:ok, from, to}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  defp get_account(id) do
    case AccountRepo.get_account(id) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  defp is_own_account?(from_id, to_id) do
    from_id == to_id
  end

  defp is_zero_or_negative_value?(value) do
    if value == 0 or Decimal.new(value) |> Decimal.negative?(), do: true, else: false
  end

  defp is_insufficient_balance?(from_value, value) do
    Decimal.sub(from_value, value) |> Decimal.negative?()
  end

  defp operation(account, value, :sub) do
    account
    |> Account.changeset(%{balance: Decimal.sub(account.balance, value) |> Decimal.to_integer()})
  end

  defp operation(account, value, :add) do
    account
    |> Account.changeset(%{balance: Decimal.add(account.balance, value) |> Decimal.to_integer()})
  end

  defp validate_transaction(account, value, type) do
    %Transaction{
      value: value,
      account: account,
      type: type
    }
    |> Transaction.changeset()
  end

  defp validate_transaction_link(transaction, transaction_link_id) do
    transaction
    |> Transaction.changeset(%{transaction_link_id: transaction_link_id})
  end
end
