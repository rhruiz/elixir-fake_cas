defmodule FakeCas.Mixfile do
  use Mix.Project

  def version, do: "1.4.0"

  def project do
    [
      app: :fake_cas,
      version: version(),
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: "A Cas server stub with deterministic responses",
      docs: [
        extras: ["README.md", "CONTRIBUTING.md", "LICENSE.md"]
      ],
      deps: deps()
    ]
  end

  def package do
    [
      files: ["mix.exs", "lib", "README.md", "LICENSE.md"],
      maintainers: ["Ricardo Hermida Ruiz"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/rhruiz/elixir-fake_cas",
        "Docs" => "https://hexdocs.pm/fake_cas/#{version()}"
      }
    ]
  end

  def application do
    [applications: [:logger, :plug]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.11", only: :dev},
      {:earmark, "~> 1.0", only: :dev},
      {:cowboy, "~> 1.0 or ~> 2.0"},
      {:plug, "~> 1.1"},
      {:plug_cowboy, "~> 1.0 or ~> 2.0"},
      {:httpoison, "~> 0.8 or ~> 1.0", only: :test}
    ]
  end
end
