defmodule Bichu.Repo do
  use Ecto.Repo,
    otp_app: :bichu,
    adapter: Ecto.Adapters.Postgres
end
