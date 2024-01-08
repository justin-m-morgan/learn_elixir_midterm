defmodule Exchangy.UseCases.SendMoney do
  @moduledoc """
  Captures the operation of transferring money from one wallet to another.
  """
  alias Ecto.Multi
  alias Exchangy.{Repo, Transactions, Wallets}

  def new(from_wallet_owner_id, to_wallet_owner_id, %Money{} = amount, to_currency) do
    with {:ok, %Wallets.Wallet{} = from_wallet} <-
           Wallets.find_wallet(%{owner_id: from_wallet_owner_id}),
         {:ok, %Wallets.Wallet{} = to_wallet} <-
           Wallets.find_wallet(%{owner_id: to_wallet_owner_id}),
         {:ok, debit_amount} = Money.mult(amount, -1),
         {:ok, credit_amount} <- convert_currency(amount, to_currency) do
      Multi.new()
      |> Multi.update(:from_wallet, Wallets.update_wallet_balance(from_wallet, debit_amount))
      |> Multi.update(:to_wallet, Wallets.update_wallet_balance(to_wallet, credit_amount))
      |> Multi.insert(
        :transaction,
        Transactions.create_transaction(%{
          from_wallet_id: from_wallet.id,
          to_wallet_id: to_wallet.id,
          from_amount: debit_amount,
          to_amount: credit_amount
        })
      )
      |> Repo.transaction()
    end
  end

  defp convert_currency(%Money{} = from_amount, to_currency) do
    {:ok, Money.new(from_amount.amount, to_currency)}
  end
end
