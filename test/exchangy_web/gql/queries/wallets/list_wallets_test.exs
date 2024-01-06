defmodule ExchangyWeb.Gql.Queries.Wallets.ListWalletsTest do
  use Exchangy.DataCase

  alias ExchangyWeb.Gql.Schema

  @list_wallets_query """
  query wallets {
    wallets {
      id
      balance
      currencyCode
    }
  }
  """

  describe "@list_wallets_query" do
    test "returns all wallets" do
      wallet_count = 10

      insert_list(wallet_count, :wallet, owner: build(:user))

      assert {:ok, %{data: data}} = Absinthe.run(@list_wallets_query, Schema, [])

      assert is_list(data["wallets"])

      assert length(data["wallets"]) == wallet_count
    end
  end
end
