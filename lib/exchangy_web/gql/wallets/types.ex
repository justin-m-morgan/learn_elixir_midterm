defmodule ExchangyWeb.Gql.Wallet.Types do
  use Absinthe.Schema.Notation

  object :wallet do
    field :id, :id
    field :currency_code, :string

    field :balance, :decimal, resolve: &extract_decimal_amount/3
  end

  defp extract_decimal_amount(wallet, _, _) do
    {:ok, wallet.balance.amount}
  end
end
