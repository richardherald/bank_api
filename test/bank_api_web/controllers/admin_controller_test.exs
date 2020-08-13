defmodule BankApiWeb.AdminControllerTest do
  use BankApiWeb.ConnCase, async: true

  import BankApi.Factory

  describe "singup/2" do
    setup %{conn: conn} do
      %{conn: conn}
    end

    test "returns 201 when admin creation is sucessful", %{conn: conn} do
      admin = params_for(:admin)

      conn = post(conn, "/api/v1/admin/sign_up", admin)

      assert %{
               "data" => %{
                 "id" => _,
                 "email" => "admin@gmail.com"
               }
             } = json_response(conn, 201)
    end

    test "returns 422 when email is empty", %{conn: conn} do
      admin = params_for(:admin, email: "")

      conn = post(conn, "/api/v1/admin/sign_up", admin)

      assert %{
               "errors" => %{
                 "email" => ["can't be blank"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when password is empty", %{conn: conn} do
      admin = params_for(:admin, password: "")

      conn = post(conn, "/api/v1/admin/sign_up", admin)

      assert %{
               "errors" => %{
                 "password" => ["can't be blank"],
                 "password_confirmation" => ["Passwords are different"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when password_confirmation is empty", %{conn: conn} do
      admin = params_for(:admin, password_confirmation: "")

      conn = post(conn, "/api/v1/admin/sign_up", admin)

      assert %{
               "errors" => %{
                 "password_confirmation" => ["Passwords are different", "can't be blank"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when email is invalid format", %{conn: conn} do
      admin = params_for(:admin, email: "richardgmail.com")

      conn = post(conn, "/api/v1/admin/sign_up", admin)

      assert %{
               "errors" => %{
                 "email" => ["Email format invalid"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when email already in used", %{conn: conn} do
      insert(:admin, email: "admin@gmail.com")
      params = params_for(:admin)

      conn = post(conn, "/api/v1/admin/sign_up", params)

      assert %{
               "errors" => %{
                 "email" => ["Email already used"]
               }
             } = json_response(conn, 422)
    end

    test "returns 422 when passwords is not equals", %{conn: conn} do
      admin = params_for(:admin, password_confirmation: "12345")

      conn = post(conn, "/api/v1/admin/sign_up", admin)

      assert %{
               "errors" => %{
                 "password_confirmation" => ["Passwords are different"]
               }
             } = json_response(conn, 422)
    end
  end
end
