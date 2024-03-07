defmodule BetsnapWeb.Api.SportsAPI do
  def get_url(), do: Application.get_env(:betsnap, :api_url) |> String.trim()
  def get_api_key(), do: Application.get_env(:betsnap, :api_key)

  def http_get(url, headers, query \\ "") do
    HTTPoison.get("#{get_url()}#{url}#{query}", headers)
  end

  def get_countries() do
    headers = [{"x-rapidapi-key", get_api_key()}]
    url = "/countries"

    case http_get(url, headers) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Unknown error"}
    end
  end

  def get_country(code) do
    headers = [{"x-rapidapi-key", get_api_key()}]
    url = "/countries?code=#{code}"

    case http_get(url, headers) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Unknown error"}
    end
  end

  def get_leagues_matches(league, from, to) do
    headers = [{"x-rapidapi-key", get_api_key()}]
    url = "/fixtures"

    from = Date.to_iso8601(from)
    to = Date.to_iso8601(to)

    query = "?league=#{league}&from=#{from}&to=#{to}&season=2023"

    case http_get(url, headers, query) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Unknown error"}
    end
  end

  def get_country_leagues(code) do
    headers = [{"x-rapidapi-key", get_api_key()}]
    url = "/leagues"

    query = "?code=#{code}&season=2023"

    case http_get(url, headers, query) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Unknown error"}
    end
  end

  def get_match(id) do
    headers = [{"x-rapidapi-key", get_api_key()}]
    url = "/fixtures"

    query = "?id=#{id}"

    case http_get(url, headers, query) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        # IO.puts "OK"
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        # IO.puts "Not found"
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        # IO.inspect reason
        {:error, reason}

      _ ->
        {:error, "Unknown error"}
    end
  end

  def get_odds(id) do
    headers = [{"x-rapidapi-key", get_api_key()}]
    url = "/odds"

    query = "?fixture=#{id}"

    case http_get(url, headers, query) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Unknown error"}
    end
  end

  def get_standings(season, league) do
    headers = [{"x-rapidapi-key", get_api_key()}]
    url = "/standings"

    query = "?season=#{season}&league=#{league}"

    case http_get(url, headers, query) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Unknown error"}
    end
  end

  def get_players(id) do
    headers = [{"x-rapidapi-key", get_api_key()}]
    url = "/players"

    query = "?team=#{id}&season=2023"

    case http_get(url, headers, query) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Unknown error"}
    end
  end

  def get_past_fixtures(id, last) do
    headers = [{"x-rapidapi-key", get_api_key()}]
    url = "/fixtures"

    query = "?team=#{id}&last=#{last}"

    case http_get(url, headers, query) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Unknown error"}
    end
  end
end
