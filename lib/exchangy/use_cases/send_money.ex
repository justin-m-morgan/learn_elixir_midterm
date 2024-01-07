defmodule Exchangy.UseCases.SendMoney do
  @moduledoc """
  Captures the operation of transferring money from one wallet to another.
  """
  alias Ecto.Multi
  alias Exchangy.Wallets

  def new(from_wallet_owner_id, to_wallet_owner_id, amount, to_currency) do
    with %Wallets.Wallet{} = from_wallet <-
           Wallets.find_wallet(%{owner_id: from_wallet_owner_id}),
         %Wallets.Wallet{} = to_wallet <- Wallets.find_wallet(%{owner_id: to_wallet_owner_id}) do
      debit_amount = Money.mult(amount, -1)
      credit_amount = convert_currency(amount, to_currency)

      Multi.new()
      |> Multi.update(:from_wallet, Wallets.update_wallet_balance(from_wallet.id, debit_amount))
      |> Multi.update(:to_wallet, Wallets.update_wallet_balance(to_wallet.id, credit_amount))
    end
  end

  defp convert_currency(%Money{} = from_amount, to_currency) do
    Money.new(from_amount.amount, to_currency)
  end
end
