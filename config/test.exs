import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :agile_exam, AgileExam.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "agile_exam_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :agile_exam, AgileExamWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4003],
  secret_key_base: "SXf0hb4ZcldE2+oNQZv1VPuFnZSYFan7rxZop+LC9d3ZGy2LX2wWPBvV1Akn1TDj",
  server: true

# Enable SQL sandbox for browser tests
config :agile_exam, :sql_sandbox, true

# In test we don't send emails
config :agile_exam, AgileExam.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Sort query params output of verified routes for robust url comparisons
config :phoenix,
  sort_verified_routes_query_params: true

config :hound,
  driver: "chrome_driver",
  browser: "chrome",
  host: "localhost",
  port: 64426
