defmodule BankApi.TransactionTest do
  use BankApi.DataCase, async: true

  import BankApi.Factory

  alias BankApi.Transactions.Transactions

  describe "run/2" do
    test "returns list of transactions" do
      user_from = insert(:user)
      insert(:transaction, account: user_from.accounts)

      params = %{start_date: "2019-01-01", end_date: "2020-08-30"}

      {:ok, transactions} = Transactions.run(user_from.accounts.id, params)
      assert is_list(transactions.result)
      assert length(transactions.result) == 1
      assert transactions.total_withdraw == 100
      assert transactions.total_deposit == 0

      [account_from_id] = Enum.map(transactions.result, & &1.account_from_id)
      {:ok, account_from} = Ecto.UUID.cast(account_from_id)

      assert account_from == user_from.accounts.id
      assert Enum.map(transactions.result, & &1.value) == [100]
    end

    test "returns empty list of transactions" do
      user_from = insert(:user)

      params = %{start_date: "2019-01-01", end_date: "2020-08-30"}

      {:ok, transactions} = Transactions.run(user_from.accounts.id, params)
      assert is_list(transactions.result)
      assert Enum.empty?(transactions.result) == true
      assert transactions.total_withdraw == 0
      assert transactions.total_deposit == 0
    end

    test "returns error when start_date is invalid date format" do
      user_from = insert(:user)

      params = %{start_date: nil, end_date: "2020-08-30"}

      assert {:error, %Ecto.Changeset{} = changeset} =
               Transactions.run(user_from.accounts.id, params)

      %{start_date: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error when end_date is invalid date format" do
      user_from = insert(:user)

      params = %{start_date: "2019-01-01", end_date: nil}

      assert {:error, %Ecto.Changeset{} = changeset} =
               Transactions.run(user_from.accounts.id, params)

      %{end_date: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
