defmodule BankApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :value, :integer, null: false
      add :account_from_id, references(:accounts, name: :account_from_id, type: :uuid), null: false
      add :account_to_id, references(:accounts, name: :account_to_id, type: :uuid)
      add :type, :string, null: false
      add :date, :date, null: false

      timestamps()
    end
  end
end
