defmodule Exchangy.WalletsTest do
  use Exchangy.DataCase

  alias Exchangy.Wallets
  alias Exchangy.Wallets.Wallet

  describe "create_wallet/1" do
    setup do
      user = insert(:user)
      %{user: user}
    end

    test "with valid data creates a wallet", %{user: user} do
      set_balance = Money.new(42, :CAD)
      valid_attrs = %{balance: set_balance, currency_code: :CAD, owner_id: user.id}

      assert {:ok, %Wallet{} = wallet} = Wallets.create_wallet(valid_attrs)
      assert wallet.balance == set_balance
      assert wallet.currency_code == :CAD
    end

    test "with invalid data returns error changeset" do
      invalid_attrs = %{balance: nil, currency_code: nil}
      assert {:error, %Ecto.Changeset{}} = Wallets.create_wallet(invalid_attrs)
    end
  end

  describe "list_wallets/1" do
    setup do
      currencies = [:CAD, :USD, :EUR, :GBP]
      owners = insert_list(4, :user)

      for owner <- owners, currency_code <- currencies do
        insert(:wallet,
          currency_code: currency_code,
          balance: Money.new(Enum.random(1..100), currency_code),
          owner: owner
        )
      end

      %{currencies: currencies, owners: owners}
    end

    test "returns all wallets", %{
      currencies: currencies,
      owners: owners
    } do
      wallets = Wallets.list_wallets()
      assert is_list(wallets)
      assert length(wallets) == length(currencies) * length(owners)
    end

    test "can filter by currency_code", %{
      owners: owners
    } do
      wallets = Wallets.list_wallets(currency_code: :CAD)
      assert length(wallets) == length(owners)
    end

    test "can filter by owner_id", %{
      currencies: currencies,
      owners: owners
    } do
      sample_owner = Enum.random(owners)
      wallets = Wallets.list_wallets(owner_id: sample_owner.id)
      assert is_list(wallets)
      assert length(wallets) == length(currencies)
    end
  end

  describe "get_wallet/1" do
    setup do
      wallet = insert(:wallet, owner: build(:user))
      %{wallet: wallet}
    end

    test "get_wallet/1 returns the wallet with given id", %{wallet: wallet} do
      fetched_wallet = Wallets.get_wallet(wallet.id)
      assert ecto_schema_primary_fields_equal?(fetched_wallet, wallet)
    end
  end

  describe "update_wallet_balance/2" do
    setup do
      wallet = insert(:wallet, owner: build(:user))
      %{wallet: wallet}
    end

    test "allows adding currency of same type", %{wallet: wallet} do
      starting_balance = wallet.balance
      add_amount = Money.new(1, wallet.currency_code)

      assert {:ok, %Wallet{} = wallet} = Wallets.update_wallet_balance(wallet, add_amount)
      assert wallet.balance == Money.add(starting_balance, add_amount)
    end

    test "allows subtracting currency of same type", %{wallet: wallet} do
      starting_balance = wallet.balance
      subtract_amount = Money.new(-1, wallet.currency_code)

      assert {:ok, %Wallet{} = wallet} = Wallets.update_wallet_balance(wallet, subtract_amount)
      assert wallet.balance == Money.add(starting_balance, subtract_amount)
    end

    test "does not allow subtracting more than the balance", %{wallet: wallet} do
      starting_balance = wallet.balance
      exceeding_subtract_amount = Money.new(-starting_balance.amount - 1, wallet.currency_code)

      assert {:error, %Ecto.Changeset{}} =
               Wallets.update_wallet_balance(wallet, exceeding_subtract_amount)
    end

    test "errors if mismatched currency" do
      wallet = insert(:wallet, owner: build(:user), currency_code: :CAD)
      add_amount = Money.new(1, :USD)

      assert_raise ArgumentError, fn ->
        Wallets.update_wallet_balance(wallet, add_amount)
      end
    end
  end
end
