defmodule BankApi.Transactions.Transactions do
  @moduledoc """
  Transaction module
  """
  import Ecto.Query, only: [from: 2]
  alias BankApi.Repo
  alias BankApi.Transactions.Schema.Transaction

  def run(account_id, start_date, end_date) do
    with {:ok, start_date, end_date} <- is_valid_dates?(start_date, end_date) do
      query =
        from(transaction_from in Transaction,
          left_join: transaction_to in Transaction,
          on: transaction_from.id == transaction_to.transaction_link_id,
          where:
            transaction_from.account_id == ^account_id and
              fragment("? BETWEEN ? AND ?", transaction_from.inserted_at, ^start_date, ^end_date),
          select: %{
            id: transaction_from.id,
            value: transaction_from.value,
            type: transaction_from.type,
            account_from_id: transaction_from.account_id,
            account_to_id: transaction_to.account_id,
            inserted_at: transaction_to.inserted_at
          }
        )

      result = Repo.all(query)
      {:ok, %{result: result, total: sum_total(result)}}
    end
  end

  defp is_valid_dates?(start_date, end_date) do
    start_date = NaiveDateTime.from_iso8601!(start_date <> " 00:00:00")
    end_date = NaiveDateTime.from_iso8601!(end_date <> " 23:59:59")

    {:ok, start_date, end_date}
  rescue
    _ in ArgumentError -> {:error, :invalid_date_format}
  end

  defp sum_total(transactions) do
    Enum.reduce(transactions, 0, fn t, acc -> acc + t.value end)
  end
end
