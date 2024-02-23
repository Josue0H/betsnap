defmodule Betsnap.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BetsnapWeb.Telemetry,
      Betsnap.Repo,
      {DNSCluster, query: Application.get_env(:betsnap, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Betsnap.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Betsnap.Finch},
      # Start a worker by calling: Betsnap.Worker.start_link(arg)
      # {Betsnap.Worker, arg},
      # Start to serve requests, typically the last entry
      BetsnapWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Betsnap.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BetsnapWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
