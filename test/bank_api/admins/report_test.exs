defmodule BankApi.ReportTest do
  use BankApi.DataCase, async: true

  import BankApi.Factory

  alias BankApi.Admins.Report

  describe "run/1" do
    setup do
      insert(:transaction, inserted_at: ~U[2021-07-14 02:17:10.506037Z], value: 100)
      insert(:transaction, inserted_at: ~U[2022-08-14 02:17:10.506037Z], value: 100)
      insert(:transaction, inserted_at: ~U[2023-04-14 02:17:10.506037Z], value: 100)
      insert(:transaction, inserted_at: ~U[2020-04-14 02:17:10.506037Z], value: 100)
      insert(:transaction, inserted_at: ~U[2020-04-14 02:17:10.506037Z], value: 100)
      :ok
    end

    test "returns total of transactions filter_by total" do
      params = %{date: "2020-08-01", filter_by: "total"}

      {:ok, total} = Report.run(params)
      assert is_number(total) == true
      assert total == 500
    end

    test "returns total of transactions filter_by year" do
      params = %{date: "2020-08-01", filter_by: "year"}

      {:ok, total} = Report.run(params)
      assert is_number(total) == true
      assert total == 200
    end

    test "returns total of transactions filter_by month" do
      params = %{date: "2020-04-01", filter_by: "month"}

      {:ok, total} = Report.run(params)
      assert is_number(total) == true
      assert total == 200
    end

    test "returns total of transactions filter_by day" do
      params = %{date: "2020-04-14", filter_by: "day"}

      {:ok, total} = Report.run(params)
      assert is_number(total) == true
      assert total == 200
    end

    test "returns error when date format invalid" do
      params = %{date: "2020-08-0", filter_by: "day"}

      assert {:error, %Ecto.Changeset{} = changeset} = Report.run(params)
      %{date: ["is invalid"]} = errors_on(changeset)
    end

    test "returns error when filter_by is invalid" do
      params = %{date: "2020-08-01", filter_by: "other"}

      assert {:error, %Ecto.Changeset{} = changeset} = Report.run(params)

      %{filter_by: ["filter_by invalid. Chosse one of the options: day, month, year or total"]} =
        errors_on(changeset)
    end
  end
end
