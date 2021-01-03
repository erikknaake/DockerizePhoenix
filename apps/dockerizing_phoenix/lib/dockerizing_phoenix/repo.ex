defmodule DockerizingPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :dockerizing_phoenix,
    adapter: Ecto.Adapters.Postgres
end
