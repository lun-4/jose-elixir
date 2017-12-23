defmodule Jose.Mixfile do
  use Mix.Project

  def project do
    [
      app: :jose,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Jose, []},
      extra_applications: [:logger, :gen_stage, :kcl, :poison, :websocket_client]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:alchemy, "~> 0.6.0", github: "cronokirby/alchemy"},
      {:jcoin, "~> 0.1.0", github: "lnmds/jcoin"},
      {:mongodb, ">= 0.0.0"},
      {:poolboy, ">= 0.0.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
    ]
  end
end
