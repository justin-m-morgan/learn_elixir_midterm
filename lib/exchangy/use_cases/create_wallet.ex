defmodule Exchangy.UseCases.CreateWallet do
  alias Exchangy.Wallets

  def create_wallet(owner_id, currency_code, initial_balance) do
    Wallets.create_wallet(%{
      owner_id: owner_id,
      currency_code: currency_code,
      balance: initial_balance
    })
  end
end
