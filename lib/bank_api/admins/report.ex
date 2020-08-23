defmodule BankApi.Admins.Report do
  @moduledoc """
  Report module
  """
  import Ecto.Query, only: [from: 2]

  alias BankApi.Admins.Schema.ReportQueryParameters
  alias BankApi.Repo
  alias BankApi.Transactions.Schema.Transaction

  @doc """
  Returns the total transacted in a specific period

  ## Parameters

    * `date` - String date to be filtered
    * `filter_by` - String filter period

  ## Examples

      iex> run(%{date: "20200801", filter_by: "day"})
      {:ok, result}

      iex> run(%{date: "20200801", filter_by: "other"})
      {:error, %Ecto.Changeset{}}
  """
  def run(params) do
    %ReportQueryParameters{}
    |> ReportQueryParameters.changeset(params)
    |> case do
      %Ecto.Changeset{valid?: true, changes: changes} ->
        report(changes)

      changeset ->
        {:error, changeset}
    end
  end

  defp report(%{date: date, filter_by: filter_by}) do
    filter(date, filter_by)
    |> Repo.aggregate(:sum, :value)
    |> case do
      nil -> {:ok, 0}
      result -> {:ok, result}
    end
  end

  defp filter(date, filter_by) when filter_by == "day" do
    from transaction in Transaction,
      where:
        (transaction.type == "deposit" or
           (transaction.type == "withdraw" and is_nil(transaction.transaction_link_id) == true)) and
          fragment("date(date_trunc('day', ?))", transaction.inserted_at) == ^date
  end

  defp filter(date, filter_by) when filter_by == "month" do
    from transaction in Transaction,
      where:
        (transaction.type == "deposit" or
           (transaction.type == "withdraw" and is_nil(transaction.transaction_link_id) == true)) and
          fragment("date(date_trunc('month', ?))", transaction.inserted_at) ==
            ^date_trunc(date, :month)
  end

  defp filter(date, filter_by) when filter_by == "year" do
    from transaction in Transaction,
      where:
        (transaction.type == "deposit" or
           (transaction.type == "withdraw" and is_nil(transaction.transaction_link_id) == true)) and
          fragment("date(date_trunc('year', ?))", transaction.inserted_at) ==
            ^date_trunc(date, :year)
  end

  defp filter(_date, filter_by) when filter_by == "total" do
    from transaction in Transaction,
      where:
        transaction.type == "deposit" or
          (transaction.type == "withdraw" and is_nil(transaction.transaction_link_id) == true)
  end

  def date_trunc(date, :month) do
    if date.month <= 9 do
      {:ok, date} = Date.from_iso8601("#{date.year}-0#{date.month}-01")
      date
    else
      {:ok, date} = Date.from_iso8601("#{date.year}-#{date.month}-01")
      date
    end
  end

  def date_trunc(date, :year) do
    {:ok, date} = Date.from_iso8601("#{date.year}-01-01")
    date
  end
end
