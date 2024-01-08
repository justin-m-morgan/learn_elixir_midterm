defmodule Exchangy.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exchangy.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        from_amount: 120.5,
        to_amount: 120.5
      })
      |> Exchangy.Transactions.create_transaction()

    transaction
  end
end
