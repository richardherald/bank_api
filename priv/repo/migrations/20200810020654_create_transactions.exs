defmodule BankApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :value, :integer, null: false
      add :account_id, references(:accounts, name: :account_id, type: :uuid), null: false
      add :type, :string, null: false
      add :transaction_link_id, :uuid

      timestamps()
    end
  end
end
