defmodule ExchangyWeb.Gql.User.Queries do
  use Absinthe.Schema.Notation

  object :user_queries do
    field :user, :user do
      arg(:id, non_null(:id))
      resolve(&get_user/3)
    end

    field :users, list_of(:user) do
      resolve(&list_users/3)
    end
  end

  def get_user(_, %{id: id}, _) do
    case Exchangy.Accounts.get_user(id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def list_users(_, _, _) do
    {:ok, Exchangy.Accounts.list_users()}
  end
end
