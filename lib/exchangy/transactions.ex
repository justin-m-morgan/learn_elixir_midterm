defmodule Exchangy.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  
  alias Exchangy.Transactions.Transaction

  @doc """
  Creates a transaction changeset.
  """
  def create_transaction(attrs \\ %{}) do
    Transaction.changeset(%Transaction{}, attrs, :create)
  end
end
