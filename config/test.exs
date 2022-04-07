import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :frontend, Frontend.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "pW53/6yVbd4HsLuGpGVNnB+vGnzCta9ksf8m3hVrJ3rc034pVkr/RJbTUjajp+qO",
  server: false
