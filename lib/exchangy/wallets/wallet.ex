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
    IO.inspect(attrs)
    wallet
    |> change()
    |> validate_change(:currency_code, fn :currency_code, currency_code ->
      IO.inspect(currency_code, label: "currency_code")
      if currency_code == attrs.balance_change.currency_code,
        do: [],
        else: [currency_code: "Currency code must match the wallet's currency code"]
    end)
    |> put_change(:balance, combine_balance_with_change(wallet, attrs.balance_change))
    |> validate_change(:balance, fn :balance, balance ->
      if Money.negative?(balance),
        do: [balance: "Balance cannot be negative"] |> IO.inspect(label: "error"),
        else: [] |> IO.inspect(label: "ok")
    end)
  end

  defp combine_balance_with_change(wallet, balance_change) do
    case Money.add(wallet.balance, balance_change) do
      {:ok, new_balance} -> new_balance
      _error -> wallet.balance
    end
  end
end
