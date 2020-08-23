defmodule BankApiWeb.FallbackControllerTest do
  use BankApiWeb.ConnCase, async: true

  import BankApiWeb.FallbackController

  describe "call/2" do
    setup %{conn: conn} do
      %{conn: conn}
    end

    test "returns 404 when error is nil", %{conn: conn} do
      conn = call(conn, nil)

      assert %{"errors" => %{"message" => ["Not found"]}} = json_response(conn, 404)
    end

    test "returns 422 when error is :transfer_your_own_account", %{conn: conn} do
      conn = call(conn, {:error, :transfer_your_own_account})

      assert %{"errors" => %{"message" => ["You cannot transfer to your own account"]}} =
               json_response(conn, 422)
    end

    test "returns 422 when error is :insufficient_balance", %{conn: conn} do
      conn = call(conn, {:error, :insufficient_balance})

      assert %{
               "errors" => %{
                 "message" => ["You don't have enough balance to perform this operation"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when error is :zero_or_negative_value", %{conn: conn} do
      conn = call(conn, {:error, :zero_or_negative_value})

      assert %{"errors" => %{"message" => ["The value cannot be zero or negative"]}} =
               json_response(conn, 422)
    end

    test "returns 422 when error is :account_not_found", %{conn: conn} do
      conn = call(conn, {:error, :account_not_found})

      assert %{"errors" => %{"message" => ["Account not found"]}} = json_response(conn, 422)
    end

    test "returns 422 when error is :username_password_invalid", %{conn: conn} do
      conn = call(conn, {:error, :username_password_invalid})

      assert %{"errors" => %{"message" => ["Username or password is invalid"]}} =
               json_response(conn, 401)
    end

    test "returns 401 when error is message", %{conn: conn} do
      conn = call(conn, {:error, "error"})

      assert %{"errors" => %{"message" => ["error"]}} = json_response(conn, 401)
    end
  end
end
