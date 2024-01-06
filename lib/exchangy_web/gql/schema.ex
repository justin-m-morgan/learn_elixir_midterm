defmodule ExchangyWeb.Gql.Schema do
  use Absinthe.Schema

  # Types
  import_types(Absinthe.Type.Custom)
  import_types(ExchangyWeb.Gql.User.Types)
  import_types(ExchangyWeb.Gql.Wallet.Types)

  # Queries
  import_types(ExchangyWeb.Gql.User.Queries)
  import_types(ExchangyWeb.Gql.Wallet.Queries)

  query do
    import_fields(:user_queries)
    import_fields(:wallet_queries)
  end
end
