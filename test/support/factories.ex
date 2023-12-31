defmodule Exchangy.Factory do
  @moduledoc """
  Manifest for individual factories.
  """

  use ExMachina.Ecto, repo: Exchangy.Repo

  use Exchangy.UserFactories
  use Exchangy.TransactionFactories
  use Exchangy.WalletFactories
end
