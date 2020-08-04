defmodule BankApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :balance, :integer
      add :user_id, references(:users, name: :id, type: :uuid)

      timestamps()
    end
  end
end
