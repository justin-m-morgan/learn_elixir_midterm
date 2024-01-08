defmodule Exchangy.TransactionFactories do
  @moduledoc false
  alias Exchangy.Transactions.Transaction

  defmacro __using__(_opts) do
    quote do
      def transaction_factory do
        currencies = ~w/CAD USD EUR GBP/a

        %Transaction{
          from_wallet_id: Enum.random(1..100_000),
          to_wallet_id: Enum.random(1..100_000),
          from_amount: Money.new(Enum.random(currencies), Enum.random(1..100)),
          to_amount: Money.new(Enum.random(currencies), Enum.random(1..100))
        }
      end
    end
  end
end
