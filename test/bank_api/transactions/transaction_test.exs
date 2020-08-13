defmodule BankApi.TransactionTest do
  use BankApi.DataCase, async: true

  import BankApi.Factory

  alias BankApi.Transactions.Transactions

  describe "run/3" do
    test "returns list of transactions" do
      user_from = insert(:user)
      insert(:transaction, account: user_from.accounts)

      start_date = "2019-01-01"
      end_date = "2020-10-30"

      {:ok, transactions} = Transactions.run(user_from.accounts.id, start_date, end_date)
      assert is_list(transactions.result)
      assert length(transactions.result) == 1
      assert transactions.total == 100
      assert Enum.map(transactions.result, & &1.account_from_id) == [user_from.accounts.id]
      assert Enum.map(transactions.result, & &1.value) == [100]
    end

    test "returns empty list of transactions" do
      user_from = insert(:user)

      start_date = "2019-01-01"
      end_date = "2020-08-30"

      {:ok, transactions} = Transactions.run(user_from.accounts.id, start_date, end_date)
      assert is_list(transactions.result)
      assert Enum.empty?(transactions.result) == true
      assert transactions.total == 0
    end

    test "returns error when start_date is invalid date format" do
      user_from = insert(:user)

      start_date = nil
      end_date = "2020-08-30"

      {:error, :invalid_date_format} =
        Transactions.run(user_from.accounts.id, start_date, end_date)
    end

    test "returns error when end_date is invalid date format" do
      user_from = insert(:user)

      start_date = "2019-01-01"
      end_date = nil

      {:error, :invalid_date_format} =
        Transactions.run(user_from.accounts.id, start_date, end_date)
    end
  end
end
