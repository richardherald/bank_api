defmodule BankApi.CreateAdminTest do
  use BankApi.DataCase, async: true

  alias BankApi.Users.Schema.{User, Account}
  alias BankApi.Users.CreateUser

  describe "run/1" do
    test "returns a struct when the params are valid" do
      params = %{
        name: "Richard",
        email: "Richard@gmail.com",
        password: "123456",
        password_confirmation: "123456"
      }

      {:ok, %User{} = user, %Account{} = account} = CreateUser.run(params)

      assert user.name == "Richard"
      assert user.email == "Richard@gmail.com"
      refute user.password_hash == "123456"

      assert account.balance == 1000
    end

    test "returns error when name is missing" do
      params = %{
        name: "",
        email: "Richard@gmail.com",
        password: "123456",
        password_confirmation: "123456"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateUser.run(params)
      %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error when email is missing" do
      params = %{
        name: "Richard",
        email: "",
        password: "123456",
        password_confirmation: "123456"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateUser.run(params)
      %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error when email is not valid" do
      params = %{
        name: "Richard",
        email: "Richardgmail.com",
        password: "123456",
        password_confirmation: "123456"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateUser.run(params)
      %{email: ["Email format invalid"]} = errors_on(changeset)
    end

    test "returns error when password is missing" do
      params = %{
        name: "Richard",
        email: "Richard@gmail.com",
        password: "",
        password_confirmation: "123456"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateUser.run(params)
      %{password: ["can't be blank"]} = errors_on(changeset)
      %{password_confirmation: ["Passwords are different"]} = errors_on(changeset)
    end

    test "returns error when password_confirmation is missing" do
      params = %{
        name: "Richard",
        email: "Richard@gmail.com",
        password: "123456",
        password_confirmation: ""
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateUser.run(params)
      %{password_confirmation: ["Passwords are different", "can't be blank"]} = errors_on(changeset)
    end

    test "returns error when passwords is not equals" do
      params = %{
        name: "Richard",
        email: "Richard@gmail.com",
        password: "123456",
        password_confirmation: "12345"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = CreateUser.run(params)
      %{password_confirmation: ["Passwords are different"]} = errors_on(changeset)
    end
  end
end
