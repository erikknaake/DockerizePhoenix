defmodule DockerizingPhoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DockerizingPhoenix.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: DockerizingPhoenix.PubSub}
      # Start a worker by calling: DockerizingPhoenix.Worker.start_link(arg)
      # {DockerizingPhoenix.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: DockerizingPhoenix.Supervisor)
  end
end
