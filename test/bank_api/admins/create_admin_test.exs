defmodule BankApi.CreateAdminTest do
  use BankApi.DataCase, async: true

  import BankApi.Factory

  alias BankApi.Admins.CreateAdmin
  alias BankApi.Admins.Schema.Admin

  describe "run/1" do
    test "returns a struct when the params are valid" do
      params = %{
        email: "admin@gmail.com",
        password: "123456",
        password_confirmation: "123456"
      }

      {:ok, %Admin{} = admin} = CreateAdmin.run(params)

      assert admin.email == "admin@gmail.com"
      refute admin.password_hash == "123456"
    end

    test "returns error when email is missing" do
      params = %{
        email: "",
        password: "123456",
        password_confirmation: "123456"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateAdmin.run(params)
      %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error when email is not valid" do
      params = %{
        email: "admingmail.com",
        password: "123456",
        password_confirmation: "123456"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateAdmin.run(params)
      %{email: ["Email format invalid"]} = errors_on(changeset)
    end

    test "returns error when email already in used" do
      insert(:admin)

      params = %{
        email: "admin@gmail.com",
        password: "123456",
        password_confirmation: "123456"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateAdmin.run(params)
      %{email: ["Email already used"]} = errors_on(changeset)
    end

    test "returns error when password is missing" do
      params = %{
        email: "admin@gmail.com",
        password: "",
        password_confirmation: "123456"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateAdmin.run(params)
      %{password: ["can't be blank"]} = errors_on(changeset)
      %{password_confirmation: ["Passwords are different"]} = errors_on(changeset)
    end

    test "returns error when password_confirmation is missing" do
      params = %{
        email: "admin@gmail.com",
        password: "123456",
        password_confirmation: ""
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateAdmin.run(params)

      %{password_confirmation: ["Passwords are different", "can't be blank"]} =
        errors_on(changeset)
    end

    test "returns error when passwords is not equals" do
      params = %{
        email: "admin@gmail.com",
        password: "123456",
        password_confirmation: "12345"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateAdmin.run(params)
      %{password_confirmation: ["Passwords are different"]} = errors_on(changeset)
    end
  end
end
