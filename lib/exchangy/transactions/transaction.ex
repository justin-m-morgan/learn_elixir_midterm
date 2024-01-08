defmodule Exchangy.Transactions.Transaction do
  @moduledoc """
  The transaction schema defines the state of a transaction.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Exchangy.Wallets.Wallet

  schema "transactions" do
    field :from_amount, Money.Ecto.Composite.Type
    field :to_amount, Money.Ecto.Composite.Type
    belongs_to :from_wallet, Wallet
    belongs_to :to_wallet, Wallet 

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs, action \\ :create) 
  def changeset(transaction, attrs, :create) do
    transaction
    |> cast(attrs, [:from_amount, :to_amount, :from_wallet_id, :to_wallet_id])
    |> validate_required([:from_amount, :to_amount, :from_wallet_id, :to_wallet_id])
  end
end
