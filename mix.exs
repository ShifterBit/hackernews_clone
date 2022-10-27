defmodule HackernewsClone.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [
        hn_server: [
          applications: [frontend: :permanent, backend: :permanent],
          include_executable_for: [:unix]
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:phoenix_live_view, "~> 0.17.5"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      "phx.routes": "phx.routes Frontend.Router"
    ]
  end
end
