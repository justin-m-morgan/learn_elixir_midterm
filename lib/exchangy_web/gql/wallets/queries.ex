defmodule ExchangyWeb.Gql.Wallet.Queries do
  use Absinthe.Schema.Notation

  object :wallet_queries do
    field :wallet, :wallet do
      arg(:id, non_null(:id))
      resolve(&get_wallet/3)
    end

    field :wallets, list_of(:wallet) do
      resolve(&list_wallets/3)
    end
  end

  def get_wallet(_, %{id: id}, _) do
    case Exchangy.Wallets.get_wallet(id) do
      nil -> {:error, "Wallet not found"}
      user -> {:ok, user}
    end
  end

  def list_wallets(_, _, _) do
    {:ok, Exchangy.Wallets.list_wallets()}
  end
end
