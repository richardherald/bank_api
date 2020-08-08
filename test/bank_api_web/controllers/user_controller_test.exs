defmodule BankApiWeb.UserControllerTest do
  use BankApiWeb.ConnCase, async: true

  import BankApi.Factory

  describe "signin/2" do
    setup %{conn: conn} do
      insert(:user)
      %{conn: conn}
    end

    test "returns 200 when credentials are valid", %{conn: conn} do
      conn =
        post(conn, "/api/v1/sign_in", %{"email" => "Richard@gmail.com", "password" => "123456"})

      assert %{"status" => "ok", "data" => %{"token" => _}} = json_response(conn, 200)
    end

    test "returns 401 when email is invalid", %{conn: conn} do
      conn = post(conn, "/api/v1/sign_in", %{"email" => "ri@gmail.com", "password" => "123456"})

      assert %{"errors" => %{"message" => ["username or password invalid"]}} = json_response(conn, 401)
    end

    test "returns 401 when password is invalid", %{conn: conn} do
      conn =
        post(conn, "/api/v1/sign_in", %{"email" => "Richard@gmail.com", "password" => "1234567"})

      assert %{"errors" => %{"message" => ["username or password invalid"]}} = json_response(conn, 401)
    end
  end
end
