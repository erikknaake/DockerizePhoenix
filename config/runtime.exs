import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :dockerizing_phoenix, DockerizingPhoenix.Repo,
       url: database_url

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :dockerizing_phoenix_web, DockerizingPhoenixWeb.Endpoint,
       secret_key_base: secret_key_base
