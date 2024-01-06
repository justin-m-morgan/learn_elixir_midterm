defmodule ExchangyWeb.Gql.User.Mutations do
  use Absinthe.Schema.Notation

  alias Exchangy.Accounts

  object :user_mutations do
    field :create_user, :user do
      arg(:input, :create_user_input)
      resolve(&create_user/3)
    end
  end

  input_object :create_user_input do
    field :name, non_null(:string)
  end

  def create_user(_, %{input: input}, _context) do
    Accounts.create_user(input)
  end
end
