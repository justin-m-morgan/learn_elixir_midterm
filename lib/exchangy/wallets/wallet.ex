defmodule Exchangy.Wallets.Wallet do
  @moduledoc """
  The wallet schema defines the state of a user's wallet.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Exchangy.Accounts.User

  schema "wallets" do
    field :balance, Money.Ecto.Composite.Type
    field :currency_code, Ecto.Enum, values: [:CAD, :USD, :EUR, :GBP]
    belongs_to :owner, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wallet, attrs, action \\ :create)

  def changeset(wallet, attrs, :create) do
    wallet
    |> cast(attrs, [:currency_code, :balance, :owner_id])
    |> validate_required([:currency_code, :balance, :owner_id])
  end

  def changeset(wallet, attrs, :balance_change) do
    wallet
    |> change()
    |> put_change(:balance, Money.add(wallet.balance, attrs.balance_change))
    |> validate_change(:balance, fn :balance, balance ->
      if balance < Money.new(0, balance.currency) do
        [balance: "Balance cannot be negative"]
      else
        []
      end
    end)
  end
end
