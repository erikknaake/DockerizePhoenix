# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :dockerizing_phoenix, DockerizingPhoenix.Repo,
  # ssl: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :dockerizing_phoenix_web, DockerizingPhoenixWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
