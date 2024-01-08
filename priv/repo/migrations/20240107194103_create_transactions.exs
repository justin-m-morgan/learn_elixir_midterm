defmodule Exchangy.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :from_amount, :money_with_currency
      add :to_amount, :money_with_currency
      add :from_wallet_id, references(:wallets, on_delete: :nothing)
      add :to_wallet_id, references(:wallets, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:from_wallet_id])
    create index(:transactions, [:to_wallet_id])
  end
end
