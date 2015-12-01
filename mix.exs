defmodule Fortune.Mixfile do
  use Mix.Project

  def project do
    [app: :fortune,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript_config,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:bump, "~> 0.1.0"},
    {:heapq, "~> 0.0.1"},
    {:red_black_tree, "~> 1.2"}]

  end

  defp escript_config do
    [main_module: Fortune]
  end
end
