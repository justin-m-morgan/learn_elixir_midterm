defmodule Exchangy.Wallets do
  @moduledoc """
  The Wallets context.
  """

  import Ecto.Query, warn: false
  alias Exchangy.Repo

  alias EctoShorts.Actions
  alias Exchangy.Wallets.Wallet

  @doc """
  Returns the list of wallets.

  ## Examples

      iex> list_wallets()
      [%Wallet{}, ...]

  """
  def list_wallets(opts \\ %{}) do
    Actions.all(Wallet, opts)
  end

  @doc """
  Gets a single wallet.


  ## Examples

      iex> get_wallet!(123)
      %Wallet{}

      iex> get_wallet!(456)
      nil
  """
  def get_wallet(id, opts \\ []) do
    Actions.get(Wallet, id, opts)
  end

  @doc """
  Creates a wallet.

  ## Examples

      iex> create_wallet(%{field: value})
      {:ok, %Wallet{}}

      iex> create_wallet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet(attrs \\ %{}) do
    %Wallet{}
    |> Wallet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet's balance. Can be a positive or negative change.

  ## Examples

      iex> update_wallet(wallet, %{field: new_value})
      {:ok, %Wallet{}}

      iex> update_wallet(wallet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet_balance(%Wallet{} = wallet, balance_change)
      when wallet.balance.currency != balance_change.currency,
      do: {:error, :currency_mismatch}

  def update_wallet_balance(%Wallet{} = wallet, balance_change) do
    wallet
    |> Wallet.changeset(%{balance_change: balance_change}, :balance_change)
    |> Repo.update()
  end
end
