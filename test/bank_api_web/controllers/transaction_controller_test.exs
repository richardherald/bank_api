defmodule BankApiWeb.TransactionControllerTest do
  use BankApiWeb.ConnCase, async: true

  import BankApi.Factory
  import BankApiWeb.UserAuth

  describe "transactions/2" do
    setup %{conn: conn} do
      conn = authenticate(conn)
      %{conn: conn}
    end

    test "returns 200 with a list of transactions", %{conn: conn} do
      user = insert(:user, email: "ygor@gmail.com")
      conn = authenticate(conn, user)

      insert(:transaction,
        account: user.accounts,
        type: "withdraw",
        value: 50,
        inserted_at: ~N[2020-08-02 12:43:54]
      )

      conn =
        get(conn, "/api/v1/transactions", %{
          "start_date" => "2020-01-01",
          "end_date" => "2020-08-30"
        })

      assert %{
               "data" => %{
                 "total" => 50,
                 "transactions" => [
                   %{
                     "account_from_id" => _,
                     "account_to_id" => nil,
                     "date" => _,
                     "id" => _,
                     "type" => "withdraw",
                     "value" => 50
                   }
                 ]
               }
             } = json_response(conn, 200)
    end

    test "returns 200 with a empty list of transactions", %{conn: conn} do
      user = insert(:user, email: "ygor@gmail.com")
      conn = authenticate(conn, user)

      insert(:transaction,
        account: user.accounts,
        type: "withdraw",
        value: 50,
        inserted_at: ~N[2020-09-02 12:43:54]
      )

      conn =
        get(conn, "/api/v1/transactions", %{
          "start_date" => "2020-01-01",
          "end_date" => "2020-08-30"
        })

      assert %{"data" => %{"total" => 0, "transactions" => []}} = json_response(conn, 200)
    end

    test "returns 422 when start_date is invalid date format", %{conn: conn} do
      conn = get(conn, "/api/v1/transactions", %{"start_date" => nil, "end_date" => "2020-08-30"})

      assert %{"errors" => %{"start_date" => ["can't be blank"]}} = json_response(conn, 422)
    end

    test "returns 422 when end_date is invalid date format", %{conn: conn} do
      conn = get(conn, "/api/v1/transactions", %{"start_date" => "2020-01-01", "end_date" => nil})

      assert %{"errors" => %{"end_date" => ["can't be blank"]}} = json_response(conn, 422)
    end
  end
end
