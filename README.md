# FakeCAS

Stubs a CAS server HTTP responses

## Installation

The package can be installed as:

  1. Add fake_cas to your list of dependencies in `mix.exs`:

        def deps do
          [{:fake_cas, "~> 1.0.0"}]
        end

  2. Ensure fake_cas is started before your application:

        def application do
          [applications: [:fake_cas]]
        end

