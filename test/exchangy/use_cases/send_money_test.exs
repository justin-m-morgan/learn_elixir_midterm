defmodule Exchangy.UseCases.SendMoneyTest do
  use Exchangy.DataCase

  alias Exchangy.UseCases.SendMoney
  alias Exchangy.Transactions.Transaction
  alias Exchangy.Wallets.Wallet

  describe "new/4" do
    setup do
      initial_balances = %{credit: Money.new(:CAD, 100), debit: Money.new(:CAD, 100)}
      debit_wallet = insert(:wallet, balance: initial_balances.debit, owner: build(:user))
      credit_wallet = insert(:wallet, balance: initial_balances.credit, owner: build(:user))
      transfer_amount = Money.new(:CAD, 50)

      assert {:ok, result} =
               SendMoney.new(
                 debit_wallet.owner_id,
                 credit_wallet.owner_id,
                 transfer_amount,
                 :CAD
               )

      %{
        debit_wallet: debit_wallet,
        credit_wallet: credit_wallet,
        initial_balances: initial_balances,
        result: result,
        transfer_amount: transfer_amount
      }
    end

    test "should debit the `from` wallet", %{
      initial_balances: initial_balances,
      debit_wallet: debit_wallet,
      transfer_amount: transfer_amount
    } do
      %{balance: current_debit_balance} = Repo.get(Wallet, debit_wallet.id)
      {:ok, expected_debit_balance} = Money.sub(initial_balances.debit, transfer_amount)
      assert current_debit_balance == expected_debit_balance
    end

    test "should credit the `to` wallet", %{
      initial_balances: initial_balances,
      credit_wallet: credit_wallet,
      transfer_amount: transfer_amount
    } do
      %{balance: current_credit_balance} = Repo.get(Wallet, credit_wallet.id)
      {:ok, expected_credit_balance} = Money.add(initial_balances.credit, transfer_amount)
      assert current_credit_balance == expected_credit_balance
    end

    test "should create a transaction", %{
      result: result,
      debit_wallet: debit_wallet,
      credit_wallet: credit_wallet
    } do
      assert %Transaction{} = transaction = Repo.get(Transaction, result[:transaction].id)
      assert transaction.from_wallet_id == debit_wallet.id
      assert transaction.to_wallet_id == credit_wallet.id
    end
  end
end
