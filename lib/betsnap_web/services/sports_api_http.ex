defmodule BetsnapWeb.Services.SportsAPI.HTTP do
  @moduledoc """
  Module to handle HTTP requests to the sports API
  """

  @behaviour BetsnapWeb.Services.SportsAPI

  def get_url(), do: Application.get_env(:betsnap, :api_url)
  def get_api_key(), do: Application.get_env(:betsnap, :api_key)

  defp get_headers do
    [{"x-rapidapi-key", get_api_key()}]
  end

  defp api_url(endpoint, query \\ "") do
    "#{get_url()}#{endpoint}#{query}"
  end

  def get_countries() do
    api_url("/countries")
    |> HTTPoison.get(get_headers())
    |> handle_response()
  end

  def get_country(code) do
    api_url("/countries", "?code=#{code}")
    |> HTTPoison.get(get_headers())
    |> handle_response()
  end

  def get_leagues_matches(league, from, to) do
    from = Date.to_iso8601(from)
    to = Date.to_iso8601(to)

    api_url("/fixtures", "?league=#{league}&from=#{from}&to=#{to}&season=2023")
    |> HTTPoison.get(get_headers())
    |> handle_response()
  end

  def get_country_leagues(code) do
    api_url("/leagues", "?code=#{code}&season=2023")
    |> HTTPoison.get(get_headers())
    |> handle_response()
  end

  def get_match(id) do
    api_url("/fixtures", "?id=#{id}")
    |> HTTPoison.get(get_headers())
    |> handle_response()
  end

  def get_odds(id) do
    api_url("/odds", "?fixture=#{id}")
    |> HTTPoison.get(get_headers())
    |> handle_response()
  end

  def get_standings(season, league) do
    api_url("/standings", "?season=#{season}&league=#{league}")
    |> HTTPoison.get(get_headers())
    |> handle_response()
  end

  def get_players(id) do
    api_url("/players", "?team=#{id}&season=2023")
    |> HTTPoison.get(get_headers())
    |> handle_response()
  end

  def get_past_fixtures(id, last) do
    api_url("/fixtures", "?team=#{id}&last=#{last}")
    |> HTTPoison.get(get_headers())
    |> handle_response()
  end

  defp handle_response({:ok, %{body: body, status_code: 200}}) do
    {:ok, Poison.decode!(body)}
  end

  defp handle_response({:ok, %{status_code: _status, body: body}}) do
    message =
      Poison.Parser.parse!(body)
      |> get_in(["message"])

    {:error, message}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end
end
