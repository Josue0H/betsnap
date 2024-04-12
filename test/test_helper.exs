Mox.defmock(BetsnapWeb.Services.SportsAPI.Mock, for: BetsnapWeb.Services.SportsAPI)

Application.put_env(
  :betsnap_web,
  BetsnapWeb.Services.SportsAPI,
  BetsnapWeb.Services.SportsAPI.Mock
)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Betsnap.Repo, :manual)
