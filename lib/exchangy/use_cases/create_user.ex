defmodule Exchangy.UseCases.CreateUser do
  alias Exchangy.Accounts

  def create_user(name) do
    Accounts.create_user(%{name: name})
  end
end
