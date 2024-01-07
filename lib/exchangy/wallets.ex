defmodule Exchangy.Wallets do
  @moduledoc """
  The Wallets context.
  """

  alias EctoShorts.Actions
  alias Exchangy.Repo
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

      iex> get_wallet(123)
      %Wallet{}

      iex> get_wallet(456)
      nil
  """
  def get_wallet(id, opts \\ []) do
    Actions.get(Wallet, id, opts)
  end

  @doc """
  Find a wallet by given parameters.

  ## Examples

      iex> find_wallet(%{owner_id: value})
      %Wallet{}

      iex> find_wallet(%{currency_code: :KLI})
      nil

  """
  def find_wallet(params) do
    Actions.find(Wallet, params)
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

      iex> update_wallet(wallet, %Money.new(:CAD, 100))
      {:ok, %Wallet{}}

      iex> update_wallet(wallet, %Money.new(:KLI, -1_000_000)
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet_balance(%Wallet{} = wallet, balance_change) do
    Wallet.changeset(wallet, %{balance_change: balance_change}, :balance_change)
  end
end
