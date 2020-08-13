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

      assert %{"data" => %{"token" => _}} = json_response(conn, 200)
    end

    test "returns 401 when email is invalid", %{conn: conn} do
      conn = post(conn, "/api/v1/sign_in", %{"email" => "ri@gmail.com", "password" => "123456"})

      assert %{"errors" => %{"message" => ["username or password invalid"]}} =
               json_response(conn, 401)
    end

    test "returns 401 when password is invalid", %{conn: conn} do
      conn =
        post(conn, "/api/v1/sign_in", %{"email" => "richard@gmail.com", "password" => "1234567"})

      assert %{"errors" => %{"message" => ["username or password invalid"]}} =
               json_response(conn, 401)
    end
  end

  describe "singup/2" do
    setup %{conn: conn} do
      %{conn: conn}
    end

    test "returns 201 when user creation is sucessful", %{conn: conn} do
      user = params_for(:user)

      conn = post(conn, "/api/v1/sign_up", user)

      assert %{
               "data" => %{
                 "id" => _,
                 "name" => "Richard",
                 "email" => "Richard@gmail.com",
                 "account" => %{"balance" => 1000, "id" => _}
               }
             } = json_response(conn, 201)
    end

    test "returns 422 when name is empty", %{conn: conn} do
      user = params_for(:user, email: "")

      conn = post(conn, "/api/v1/sign_up", user)

      assert %{
               "errors" => %{
                 "email" => ["can't be blank"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when email is empty", %{conn: conn} do
      user = params_for(:user, email: "")

      conn = post(conn, "/api/v1/sign_up", user)

      assert %{
               "errors" => %{
                 "email" => ["can't be blank"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when password is empty", %{conn: conn} do
      user = params_for(:user, password: "")

      conn = post(conn, "/api/v1/sign_up", user)

      assert %{
               "errors" => %{
                 "password" => ["can't be blank"],
                 "password_confirmation" => ["Passwords are different"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when password_confirmation is empty", %{conn: conn} do
      user = params_for(:user, password_confirmation: "")

      conn = post(conn, "/api/v1/sign_up", user)

      assert %{
               "errors" => %{
                 "password_confirmation" => ["Passwords are different", "can't be blank"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when email is invalid format", %{conn: conn} do
      user = params_for(:user, email: "richardgmail.com")

      conn = post(conn, "/api/v1/sign_up", user)

      assert %{
               "errors" => %{
                 "email" => ["Email format invalid"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when email already in used", %{conn: conn} do
      insert(:user, email: "Richard@gmail.com")
      params = params_for(:user)

      conn = post(conn, "/api/v1/sign_up", params)

      assert %{
               "errors" => %{
                 "email" => ["Email already used"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when passwords is not equals", %{conn: conn} do
      user = params_for(:user, password_confirmation: "12345")

      conn = post(conn, "/api/v1/sign_up", user)

      assert %{
               "errors" => %{
                 "password_confirmation" => ["Passwords are different"]
               }
             } = json_response(conn, 422)
    end
  end
end
