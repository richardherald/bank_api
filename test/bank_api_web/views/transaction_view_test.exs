defmodule BankApiWeb.TransactionViewTest do
  use ExUnit.Case, async: true

  alias BankApiWeb.TransactionView

  test "render/2 returns a list of transactions" do
    transactions = %{
      result: [
        %{
          account_from_id: "ed4cbaf1-5f96-4b2d-aaf0-1a695376cec1",
          account_to_id: "3679e4c3-f241-4353-a8c2-2e929f473d42",
          id: "ecdb2aa6-f7ca-44cc-adf2-dd3cbe3da94c",
          inserted_at: ~N[2020-08-13 04:18:05],
          type: "deposit",
          value: 100
        }
      ],
      total_withdraw: 100,
      total_deposit: 100
    }

    assert %{
             data: %{
              total_withdraw: 100,
              total_deposit: 100,
               transactions: [
                 %{
                   account_from_id: "ed4cbaf1-5f96-4b2d-aaf0-1a695376cec1",
                   account_to_id: "3679e4c3-f241-4353-a8c2-2e929f473d42",
                   date: ~N[2020-08-13 04:18:05],
                   id: "ecdb2aa6-f7ca-44cc-adf2-dd3cbe3da94c",
                   type: "deposit",
                   value: 100
                 }
               ]
             }
           } = TransactionView.render("show.json", %{transactions: transactions})
  end
end
