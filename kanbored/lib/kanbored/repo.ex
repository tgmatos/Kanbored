defmodule Kanbored.Repo do
  use Ecto.Repo,
    otp_app: :kanbored,
    adapter: Ecto.Adapters.Postgres
end
