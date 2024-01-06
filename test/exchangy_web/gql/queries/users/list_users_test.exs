defmodule ExchangyWeb.Gql.Queries.Users.ListUsersTest do
  use Exchangy.DataCase

  alias ExchangyWeb.Gql.Schema

  @list_users_query """
  query ListUsers {
    users {
      id
      name
    }
  }
  """

  describe "@list_users_query" do
    test "returns all users" do
      user_count = 10
      insert_list(user_count, :user)

      assert {:ok, %{data: data}} = Absinthe.run(@list_users_query, Schema, [])

      assert is_list(data["users"])

      assert length(data["users"]) == user_count
    end
  end
end
