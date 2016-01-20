defmodule ExConstructor.Mixfile do
  use Mix.Project

  def project do
    [app: :exconstructor,
     description: "ExConstructor is a helper for instantiating structs from external data.",
     version: "0.1.2",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: [
       maintainers: ["pete gamache", "Appcues"],
       licenses: ["MIT"],
       links: %{GitHub: "https://github.com/appcues/exconstructor"}
     ],
     docs: [main: ExConstructor],
     test_coverage: [tool: ExCoveralls],
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_spec, "~> 1.0.0", only: :test},
      {:excoveralls, "~> 0.4.3", only: :test},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
    ]
  end
end

