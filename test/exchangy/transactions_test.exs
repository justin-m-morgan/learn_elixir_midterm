defmodule Exchangy.TransactionsTest do
  use Exchangy.DataCase

  alias Exchangy.Transactions

  describe "transactions" do
    test "create_transaction/1 with valid data creates a transaction" do
      attrs = params_for(:transaction)
      assert %Ecto.Changeset{} = changeset = Transactions.create_transaction(attrs)
      assert changeset.valid?
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert %Ecto.Changeset{valid?: false} =
               changeset = Transactions.create_transaction(%{from_amount: 100, to_amount: 1.1})

      Enum.each(
        [
          {:from_wallet_id, [validation: :required]},
          {:to_wallet_id, [validation: :required]},
          {:from_amount, [validation: :cast]},
          {:to_amount, [validation: :cast]}
        ],
        fn {field, expected_errors} ->
          assert {_, errors} = changeset.errors[field]

          assert Enum.all?(expected_errors, fn expected_error ->
                   expected_error in errors
                 end)
        end
      )
    end
  end
end
