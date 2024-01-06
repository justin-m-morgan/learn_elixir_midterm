defmodule Exchangy.WalletFactories do
  @moduledoc false
  alias Exchangy.Wallets.Wallet

  defmacro __using__(_opts) do
    quote do
      def wallet_factory do
        %Wallet{
          currency_code: :CAD,
          balance: Money.new(:CAD, 42)
        }
      end
    end
  end
end
