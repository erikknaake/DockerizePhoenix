defmodule DockerizingPhoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    if(System.get_env("CONNECT_TO_SERVER") != nil) do
      connect_to_cluster()
    end

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

  defp connect_to_cluster do
    # DNS lookup
    IO.puts("Node name: #{node()}")
    {lookup_result, _} = System.cmd("nslookup", ["phoenix"])

    # Parse IP out of nslookup result
    Regex.scan(~r/\d+\.\d+\.\d+\.\d+/, lookup_result)
    |> List.flatten()
      # Filter out this container
    |> Enum.reject(fn x ->
      {own_ip, 0} = System.cmd("hostname", ["-i"])
      x == own_ip
    end)
      # Connect to other node
    |> Enum.map(fn ip ->
      Node.connect(:"phoenix@#{ip}")
    end)

    IO.puts("Connected to: ")
    IO.inspect(Node.list())
  end
end
