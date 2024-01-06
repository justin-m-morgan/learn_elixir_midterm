defmodule ExchangyWeb.Gql.Wallets.Mutations do
  use Absinthe.Schema.Notation

  alias Exchangy.Wallets

  object :wallet_mutations do
    field :create_wallet, :wallet do
      arg(:input, :create_wallet_input)
      resolve(&create_wallet/3)
    end
  end

  input_object :create_wallet_input do
    field :currency_code, non_null(:string)
    field :balance, non_null(:decimal)
    field :owner_id, non_null(:id)
  end

  def create_wallet(_, %{input: input}, _context) do
    input
    |> Map.put(:balance, Money.new(input.currency_code, input.balance))
    |> Wallets.create_wallet()
  end
end
