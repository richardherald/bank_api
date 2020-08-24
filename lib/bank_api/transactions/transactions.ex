defmodule BankApi.Transactions.Transactions do
  @moduledoc """
  Transaction module
  """
  import Ecto.Query, only: [from: 2]

  alias BankApi.Repo
  alias BankApi.Transactions.Schema.{Transaction, TransactionQueryParameters}

  @doc """
  Returns a list of transactions in a specific period

  ## Parameters

    * `account_id` - String account id of the user logged
    * `filter_by` - String filter period

  ## Examples

      iex> run(%{date: "20200801", filter_by: "day"})
      {:ok, %{result: [{}], total: 100}}

      iex> run(%{date: "20200801", filter_by: "other"})
      {:error, %Ecto.Changeset{}}
  """
  def run(account_id, params) do
    %TransactionQueryParameters{}
    |> TransactionQueryParameters.changeset(params)
    |> case do
      %Ecto.Changeset{valid?: true, changes: changes} ->
        transactions(account_id, changes)

      changeset ->
        {:error, changeset}
    end
  end

  defp transactions(account_id, %{start_date: start_date, end_date: end_date}) do
    query =
      from(transaction_from in Transaction,
        left_join: transaction_to in Transaction,
        on: transaction_from.id == transaction_to.transaction_link_id,
        where:
          transaction_from.account_id == ^account_id and
            fragment(
              "date(?) BETWEEN ? and ?",
              transaction_from.inserted_at,
              ^start_date,
              ^end_date
            ),
        select: %{
          id: transaction_from.id,
          value: transaction_from.value,
          type: transaction_from.type,
          account_from_id:
            fragment(
              "case
                    when t0.type = 'withdraw' and t1.type = 'deposit' then ?
                    when t0.type = 'withdraw' and t1.id is null then ?
                    when t0.type = 'deposit' and t1.type = 'withdraw' then ?
                    end",
              transaction_from.account_id,
              transaction_from.account_id,
              transaction_to.account_id
            ),
          account_to_id:
            fragment(
              "case
                    when t0.type = 'withdraw' and t1.type = 'deposit' then ?
                    when t0.type = 'deposit' and t1.type = 'withdraw' then ?
                    end",
              transaction_to.account_id,
              transaction_from.account_id
            ),
          inserted_at: transaction_from.inserted_at
        }
      )

    result = Repo.all(query)

    {:ok,
     %{
       result: result,
       total_withdraw: sum_total(result, :withdraw),
       total_deposit: sum_total(result, :deposit)
     }}
  end

  defp sum_total(transactions, operation) do
    Enum.reduce(transactions, 0, fn t, acc ->
      if t.type == Atom.to_string(operation), do: acc + t.value, else: acc
    end)
  end
end
