defmodule ExConstructor.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exconstructor,
      version: "1.2.8",
      description: description(),
      package: package(),
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      docs: [main: ExConstructor],
      test_coverage: [tool: ExCoveralls],
      # test_coverage: [tool: Coverex.Task],
      deps: deps()
    ]
  end

  def description do
    ~S"""
    ExConstructor generates constructor functions for your structs, handling
    map-vs-keyword-list, string-vs-atom-keys, and camelCase-vs-under_score
    issues automatically.
    """
  end

  def package do
    [
      maintainers: ["pete gamache", "Appcues"],
      licenses: ["MIT"],
      links: %{GitHub: "https://github.com/appcues/exconstructor"}
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_spec, "~> 2.0.1", only: :test},
      {:excoveralls, "~> 0.14", only: :test},
      {:earmark, "~> 1.4", only: :dev},
      {:ex_doc, "~> 0.26", only: :dev},
      {:dialyxir, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
