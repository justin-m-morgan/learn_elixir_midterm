defmodule Exchangy.WalletsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exchangy.Wallets` context.
  """

  @doc """
  Generate a wallet.
  """
  def wallet_fixture(attrs \\ %{}) do
    {:ok, wallet} =
      attrs
      |> Enum.into(%{
        balance: Money.new(42, :USD),
        currency_code: "some currency_code"
      })
      |> Exchangy.Wallets.create_wallet()

    wallet
  end
end
