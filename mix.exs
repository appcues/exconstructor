defmodule ExConstructor.Mixfile do
  use Mix.Project

  @source_url "https://github.com/appcues/exconstructor"
  @version "1.2.5"

  def project do
    [
      app: :exconstructor,
      version: @version,
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def package do
    [
      description:
        "ExConstructor generates constructor functions for your structs, handling" <>
          " map-vs-keyword-list, string-vs-atom-keys, and camelCase-vs-under_score" <>
          " issues automatically.",
      maintainers: ["pete gamache", "Appcues"],
      licenses: ["MIT"],
      links: %{
        Changelog: "https://hexdocs.pm/exconstructor/changelog.html",
        GitHub: @source_url
      }
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_spec, "~> 2.0.1", only: :test},
      {:excoveralls, "~> 0.14", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"],
      api_reference: false
    ]
  end
end
