defmodule BankApi.Transactions.Transactions do
  @moduledoc """
  Transaction module
  """
  import Ecto.Query, only: [from: 2]

  alias BankApi.Repo
  alias BankApi.Transactions.Schema.{Transaction, TransactionQueryParameters}

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
          account_from_id: transaction_from.account_id,
          account_to_id: transaction_to.account_id,
          inserted_at: transaction_from.inserted_at
        }
      )

    result = Repo.all(query)
    {:ok, %{result: result, total: sum_total(result)}}
  end

  defp sum_total(transactions) do
    Enum.reduce(transactions, 0, fn t, acc -> acc + t.value end)
  end
end
