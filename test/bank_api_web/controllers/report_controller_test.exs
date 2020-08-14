defmodule BankApiWeb.ReportControllerTest do
  use BankApiWeb.ConnCase, async: true

  import BankApi.Factory
  import BankApiWeb.AdminAuth

  describe "report/2" do
    setup %{conn: conn} do
      conn = authenticate(conn)
      insert(:transaction, inserted_at: ~U[2021-07-14 02:17:10.506037Z], value: 100)
      insert(:transaction, inserted_at: ~U[2022-08-14 02:17:10.506037Z], value: 100)
      insert(:transaction, inserted_at: ~U[2023-04-14 02:17:10.506037Z], value: 100)
      insert(:transaction, inserted_at: ~U[2020-04-10 02:17:10.506037Z], value: 100)
      insert(:transaction, inserted_at: ~U[2020-04-10 02:17:10.506037Z], value: 100)
      %{conn: conn}
    end

    test "returns 200 with total transactions", %{conn: conn} do
      conn = get(conn, "/api/v1/admin/report", %{"date" => "2020-08-01", "filter_by" => "total"})

      assert %{"data" => %{"total" => 500}} = json_response(conn, 200)
    end

    test "returns 200 with total transactions by year", %{conn: conn} do
      conn = get(conn, "/api/v1/admin/report", %{"date" => "2020-08-01", "filter_by" => "year"})

      assert %{"data" => %{"total" => 200}} = json_response(conn, 200)
    end

    test "returns 200 with total transactions by month", %{conn: conn} do
      conn = get(conn, "/api/v1/admin/report", %{"date" => "2020-04-01", "filter_by" => "month"})

      assert %{"data" => %{"total" => 200}} = json_response(conn, 200)
    end

    test "returns 200 with total transactions by day", %{conn: conn} do
      conn = get(conn, "/api/v1/admin/report", %{"date" => "2020-04-10", "filter_by" => "day"})

      assert %{"data" => %{"total" => 200}} = json_response(conn, 200)
    end

    test "returns 422 when date format invalid", %{conn: conn} do
      conn = get(conn, "/api/v1/admin/report", %{"date" => "2020-4-10", "filter_by" => "day"})

      assert %{"errors" => %{"date" => ["is invalid"]}} = json_response(conn, 422)
    end

    test "returns 422 when filter_by is invalid", %{conn: conn} do
      conn = get(conn, "/api/v1/admin/report", %{"date" => "2020-04-10", "filter_by" => "other"})

      assert %{
               "errors" => %{
                 "filter_by" => [
                   "filter_by invalid. Chosse one of the options: day, month, year or total"
                 ]
               }
             } = json_response(conn, 422)
    end
  end
end
