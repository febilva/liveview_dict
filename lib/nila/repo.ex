defmodule Olam.Repo do
  use Ecto.Repo,
    otp_app: :nila,
    adapter: Ecto.Adapters.Postgres
end
