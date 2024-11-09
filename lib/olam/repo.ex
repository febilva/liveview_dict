defmodule Olam.Repo do
  use Ecto.Repo,
    otp_app: :olam,
    adapter: Ecto.Adapters.Postgres
end
