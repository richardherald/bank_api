defmodule BankApiWeb.OperationControllerTest do
  use BankApiWeb.ConnCase, async: true

  import BankApi.Factory
  import BankApiWeb.UserAuth

  describe "transfer/2" do
    setup %{conn: conn} do
      conn = authenticate(conn)
      %{conn: conn}
    end

    test "returns 200 when transfer is successfully", %{conn: conn} do
      user = insert(:user, email: "ygor@gmail.com")

      params = %{
        "to" => user.accounts.id,
        "value" => "100"
      }

      conn = post(conn, "/api/v1/operations/transfer", params)
      assert %{"status" => "ok"} = json_response(conn, 200)
    end

    test "returns error when there is not enough balance", %{conn: conn} do
      user = insert(:user, email: "ygor@gmail.com")

      params = %{
        "to" => user.accounts.id,
        "value" => "10000"
      }

      conn = post(conn, "/api/v1/operations/transfer", params)

      assert %{"errors" => %{"message" => ["You don't have enough balance to perform this operation"]}} =
               json_response(conn, 422)
    end

    test "returns error when account not found", %{conn: conn} do
      params = %{
        "to" => "0b386772-7397-45be-9a43-3fb12a617bb1",
        "value" => "100"
      }

      conn = post(conn, "/api/v1/operations/transfer", params)
      assert %{"errors" => %{"message" => ["Account not found"]}} = json_response(conn, 422)
    end
  end
end
