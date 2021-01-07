import Config

if System.get_env("MIX_ENV") == "prod" do
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

  host = System.get_env("HOST") || "localhost"
  port = String.to_integer(System.get_env("PORT") || "4000")


  config :dockerizing_phoenix_web,
         DockerizingPhoenixWeb.Endpoint,
         url: [
           host: host
         ],
         secret_key_base: secret_key_base,
         http: [
           port: port,
           transport_options: [
             socket_opts: [:inet6]
           ]
         ]
end

