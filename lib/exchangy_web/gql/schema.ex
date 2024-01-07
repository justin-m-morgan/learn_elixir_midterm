defmodule ExchangyWeb.Gql.Schema do
  use Absinthe.Schema

  # Types
  import_types(Absinthe.Type.Custom)
  import_types(ExchangyWeb.Gql.User.Types)
  import_types(ExchangyWeb.Gql.Wallet.Types)

  # Queries
  import_types(ExchangyWeb.Gql.User.Queries)
  import_types(ExchangyWeb.Gql.Wallet.Queries)

  # Mutations
  import_types(ExchangyWeb.Gql.User.Mutations)
  import_types(ExchangyWeb.Gql.Wallets.Mutations)

  query do
    import_fields(:user_queries)
    import_fields(:wallet_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:wallet_mutations)
  end
end
