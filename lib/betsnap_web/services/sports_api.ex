defmodule BetsnapWeb.Services.SportsAPI do
  @moduledoc """
  Module to handle sports API requests
  """

  @callback get_countries :: {:ok, list(map())} | {:error, term()}
  @callback get_country(String.t()) :: {:ok, map()} | {:error, term()}
  @callback get_leagues_matches(String.t(), Date.t(), Date.t()) ::
              {:ok, list(map())} | {:error, term()}
  @callback get_country_leagues(String.t()) :: {:ok, list(map())} | {:error, term()}
  @callback get_match(String.t()) :: {:ok, map()} | {:error, term()}
  @callback get_odds(String.t()) :: {:ok, list(map())} | {:error, term()}
  @callback get_standings(String.t(), String.t()) :: {:ok, list(map())} | {:error, term()}
  @callback get_players(String.t()) :: {:ok, list(map())} | {:error, term()}
  @callback get_past_fixtures(String.t(), integer()) :: {:ok, list(map())} | {:error, term()}

  def get_countries do
    impl().get_countries()
  end

  def get_country(code) do
    impl().get_country(code)
  end

  def get_leagues_matches(league, from, to) do
    impl().get_leagues_matches(league, from, to)
  end

  def get_country_leagues(code) do
    impl().get_country_leagues(code)
  end

  def get_match(id) do
    impl().get_match(id)
  end

  def get_odds(id) do
    impl().get_odds(id)
  end

  def get_standings(season, league) do
    impl().get_standings(season, league)
  end

  def get_players(id) do
    impl().get_players(id)
  end

  def get_past_fixtures(id, last) do
    impl().get_past_fixtures(id, last)
  end

  def impl do
    Application.get_env(
      :betsnap_web,
      BetsnapWeb.Services.SportsAPI,
      BetsnapWeb.Services.SportsAPI.HTTP
    )
  end
end
