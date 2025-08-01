defmodule ExConstructor.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exconstructor,
      version: "1.2.18",
      description: description(),
      package: package(),
      elixir: "~> 1.18",
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
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.14", only: :test},
      {:earmark, "~> 1.4", only: :dev},
      {:ex_doc, "~> 0.26", only: :dev},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
