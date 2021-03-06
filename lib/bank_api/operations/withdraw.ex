defmodule BankApi.Operations.Withdraw do
  @moduledoc """
  Withdraw module
  """

  alias BankApi.Repo
  alias BankApi.SendEmail
  alias BankApi.Transactions.Schema.Transaction
  alias BankApi.Users.AccountRepo
  alias BankApi.Users.Schema.Account

  @withdraw "withdraw"

  @doc """
  Withdrawing money

  ## Parameters

    * `from_id` - String account id withdraw the money
    * `value` - Integer withdrawal amount

  ## Examples

      iex> run("0b386772-7397-45be-9a43-3fb12a617bb7", 100)
      {:ok, account_from}

      iex> run("0b386772-7397-45be-9a43-3fb12a617bb7", -100)
      {:error, :negative_value}
  """
  def run(from_id, value) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.run(:is_negative_balance, fn _, _ ->
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
      |> Ecto.Multi.update(:update_account_from, fn %{account_from: account_from} ->
        operation(account_from, value, :sub)
      end)
      |> Ecto.Multi.insert(:transaction, fn %{account_from: account_from} ->
        validate_transaction(account_from, value)
      end)

    case Repo.transaction(multi) do
      {:ok, %{update_account_from: from}} ->
        Task.async(fn -> SendEmail.run() end)
        {:ok, from}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  defp get_account(id) do
    case AccountRepo.get_account(id) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
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

  defp validate_transaction(account_from, value) do
    %Transaction{
      value: value,
      account: account_from,
      type: @withdraw
    }
    |> Transaction.changeset()
  end
end
