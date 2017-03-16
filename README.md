# FakeCAS

Stubs a [CAS](https://github.com/apereo/cas) server with deterministic HTTP responses.

## Installation

The package can be installed as:

  1. Add fake_cas to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:fake_cas, "~> 1.2.0"}]
  end
  ```


  2. Ensure fake_cas is started before your application:

  ```elixir
  def application do
    [applications: [:fake_cas]]
  end
  ```


## Usage

Please refer to the docs on the `FakeCas` module or on [hexdocs](https://hexdocs.pm/fake_cas/)


## Issues and Pull requests

Here on GitHub, you know the drill.
