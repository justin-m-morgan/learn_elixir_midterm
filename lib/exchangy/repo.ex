defmodule Exchangy.Repo do
  use Ecto.Repo,
    otp_app: :exchangy,
    adapter: Ecto.Adapters.Postgres
end
