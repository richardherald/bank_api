defmodule BankApi.WithDrawTest do
  use BankApi.DataCase, async: true

  import BankApi.Factory

  alias BankApi.Operations.Withdraw

  describe "run/2" do
    test "returns struct when withdraw is completed successful" do
      account_from = insert(:user)

      {:ok, from} = Withdraw.run(account_from.accounts.id, 100)

      assert from.balance == 99_900
    end

    test "returns error when balance is negative" do
      account_from = insert(:user)

      {:error, :zero_or_negative_value} = Withdraw.run(account_from.accounts.id, -100)
    end

    test "returns error when balance is zero" do
      account_from = insert(:user)

      {:error, :zero_or_negative_value} = Withdraw.run(account_from.accounts.id, 0)
    end

    test "returns error when balance is insufficient" do
      account_from = insert(:user)

      {:error, :insufficient_balance} = Withdraw.run(account_from.accounts.id, 120_000)
    end

    test "returns error when account from is not found" do
      {:error, :account_not_found} = Withdraw.run("0b386772-7397-45be-9a43-3fb12a617bb2", 100)
    end
  end
end
