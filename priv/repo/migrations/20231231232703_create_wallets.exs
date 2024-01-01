defmodule Exchangy.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :currency_code, :string
      add :balance, :money_with_currency
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:wallets, [:owner_id])
    create unique_index(:wallets, [:owner_id, :currency_code])
  end
end
