defmodule Betsnap.Repo do
  use Ecto.Repo,
    otp_app: :betsnap,
    adapter: Ecto.Adapters.Postgres
end
