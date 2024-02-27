defmodule BetsnapWeb.Api.SportsAPI do
  @url "https://v3.football.api-sports.io"
  @api_key "13b3738787328e9e4b55e69dee2d66f7"


  def http_get(url, headers, query \\ "") do
    HTTPoison.get("#{@url}#{url}#{query}", headers)
  end

  def get_countries() do
    headers = [{"x-rapidapi-key", @api_key}]
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
    headers = [{"x-rapidapi-key", @api_key}]
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
    headers = [{"x-rapidapi-key", @api_key}]
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
    headers = [{"x-rapidapi-key", @api_key}]
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
    headers = [{"x-rapidapi-key", @api_key}]
    url = "/fixtures"


    query = "?id=#{id}"

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
