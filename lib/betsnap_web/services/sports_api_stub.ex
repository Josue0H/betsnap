defmodule BetsnapWeb.Services.SportsAPI.Stub do
  @behaviour BetsnapWeb.Services.SportsAPI

  # def get_url(), do: Application.get_env(:betsnap, :api_url)
  # def get_api_key(), do: Application.get_env(:betsnap, :api_key)

  # defp get_headers do
  #   [{"x-rapidapi-key", get_api_key()}]
  # end

  # defp api_url(endpoint, query \\ "") do
  #   "#{get_url()}#{endpoint}#{query}"
  # end

  def get_countries() do
    countries = %{
      "errors" => [],
      "get" => "countries",
      "paging" => %{"current" => 1, "total" => 1},
      "parameters" => [],
      "response" => [
        %{
          "code" => "AL",
          "flag" => "https://media.api-sports.io/flags/al.svg",
          "name" => "Albania"
        },
        %{
          "code" => "DZ",
          "flag" => "https://media.api-sports.io/flags/dz.svg",
          "name" => "Algeria"
        },
        %{
          "code" => "AD",
          "flag" => "https://media.api-sports.io/flags/ad.svg",
          "name" => "Andorra"
        },
      ]
    }

    {:ok, countries}
  end

  def get_country(_code) do
    country = %{
        "errors" => [],
        "get" => "countries",
        "paging" => %{"current" => 1, "total" => 1},
        "parameters" => %{"code" => "AL"},
        "response" => [
          %{
            "code" => "AL",
            "flag" => "https://media.api-sports.io/flags/al.svg",
            "name" => "Albania"
          }
        ],
        "results" => 1
      }

    {:ok, country}
  end

  def get_leagues_matches(_league, _from, _to) do
    leagues_matches = %{
      "errors" => [],
      "get" => "fixtures",
      "paging" => %{"current" => 1, "total" => 1},
      "parameters" => %{
        "from" => "2024-04-11",
        "league" => "39",
        "season" => "2023",
        "to" => "2024-04-18"
      },
      "response" => [
        %{
          "fixture" => %{
            "unique" => Enum.random(1..1000000),
            "date" => "2024-04-13T01:06:00+00:00",
            "id" => 1150337,
            "periods" => %{"first" => nil, "second" => nil},
            "referee" => nil,
            "status" => %{"elapsed" => nil, "long" => "Not Started", "short" => "NS"},
            "timestamp" => 1712970360,
            "timezone" => "UTC",
            "venue" => %{
              "city" => "Santiago de Quer├⌐taro",
              "id" => 20476,
              "name" => "Estadio Corregidora"
            }
          },
          "goals" => %{"away" => nil, "home" => nil},
          "league" => %{
            "country" => "Mexico",
            "flag" => "https://media.api-sports.io/flags/mx.svg",
            "id" => 262,
            "logo" => "https://media.api-sports.io/football/leagues/262.png",
            "name" => "Liga MX",
            "round" => "Clausura - 15",
            "season" => 2023
          },
          "score" => %{
            "extratime" => %{"away" => nil, "home" => nil},
            "fulltime" => %{"away" => nil, "home" => nil},
            "halftime" => %{"away" => nil, "home" => nil},
            "penalty" => %{"away" => nil, "home" => nil}
          },
          "teams" => %{
            "away" => %{
              "id" => 14002,
              "logo" => "https://media.api-sports.io/football/teams/14002.png",
              "name" => "Mazatl├ín",
              "winner" => nil
            },
            "home" => %{
              "id" => 2290,
              "logo" => "https://media.api-sports.io/football/teams/2290.png",
              "name" => "Club Queretaro",
              "winner" => nil
            }
          }
        },
        %{
          "fixture" => %{
            "date" => "2024-04-13T03:00:00+00:00",
            "id" => 1150338,
            "periods" => %{"first" => nil, "second" => nil},
            "referee" => nil,
            "status" => %{"elapsed" => nil, "long" => "Not Started", "short" => "NS"},
            "timestamp" => 1712977200,
            "timezone" => "UTC",
            "venue" => %{
              "city" => "Aguascalientes",
              "id" => 20474,
              "name" => "Estadio Victoria"
            }
          },
          "goals" => %{"away" => nil, "home" => nil},
          "league" => %{
            "country" => "Mexico",
            "flag" => "https://media.api-sports.io/flags/mx.svg",
            "id" => 262,
            "logo" => "https://media.api-sports.io/football/leagues/262.png",
            "name" => "Liga MX",
            "round" => "Clausura - 15",
            "season" => 2023
          },
          "score" => %{
            "extratime" => %{"away" => nil, "home" => nil},
            "fulltime" => %{"away" => nil, "home" => nil},
            "halftime" => %{"away" => nil, "home" => nil},
            "penalty" => %{"away" => nil, "home" => nil}
          },
          "teams" => %{
            "away" => %{
              "id" => 2285,
              "logo" => "https://media.api-sports.io/football/teams/2285.png",
              "name" => "Santos Laguna",
              "winner" => nil
            },
            "home" => %{
              "id" => 2288,
              "logo" => "https://media.api-sports.io/football/teams/2288.png",
              "name" => "Necaxa",
              "winner" => nil
            }
          }
        }
      ]
    }


    {:ok, leagues_matches}
  end

  def get_country_leagues(_code) do
    country_leagues = %{
      "response" => [
        %{
          "country" => %{
            "code" => "AL",
            "flag" => "https://media.api-sports.io/flags/al.svg",
            "name" => "Albania"
          },
          "league" => %{
            "id" => 310,
            "logo" => "https://media.api-sports.io/football/leagues/310.png",
            "name" => "Superliga",
            "type" => "League"
          },
          "seasons" => [
            %{
              "coverage" => %{
                "fixtures" => %{
                  "events" => true,
                  "lineups" => true,
                  "statistics_fixtures" => false,
                  "statistics_players" => false
                },
                "injuries" => false,
                "odds" => true,
                "players" => true,
                "predictions" => true,
                "standings" => true,
                "top_assists" => true,
                "top_cards" => true,
                "top_scorers" => true
              },
              "current" => true,
              "end" => "2024-05-11",
              "start" => "2023-08-26",
              "year" => 2023
            }
          ]
        }
      ]
    }




    {:ok, country_leagues}
  end

  def get_match(_id) do
    match = %{
      "response" => [
        %{
          "events" => [],
          "fixture" => %{
            "date" => "2024-04-13T23:00:00+00:00",
            "id" => 1150340,
            "periods" => %{"first" => nil, "second" => nil},
            "referee" => nil,
            "status" => %{"elapsed" => nil, "long" => "Not Started", "short" => "NS"},
            "timestamp" => 1713049200,
            "timezone" => "UTC",
            "venue" => %{
              "city" => "Pachuca de Soto",
              "id" => 1081,
              "name" => "Estadio Hidalgo"
            }
          },
          "goals" => %{"away" => nil, "home" => nil},
          "league" => %{
            "country" => "Mexico",
            "flag" => "https://media.api-sports.io/flags/mx.svg",
            "id" => 262,
            "logo" => "https://media.api-sports.io/football/leagues/262.png",
            "name" => "Liga MX",
            "round" => "Clausura - 15",
            "season" => 2023
          },
          "lineups" => [],
          "players" => [],
          "score" => %{
            "extratime" => %{"away" => nil, "home" => nil},
            "fulltime" => %{"away" => nil, "home" => nil},
            "halftime" => %{"away" => nil, "home" => nil},
            "penalty" => %{"away" => nil, "home" => nil}
          },
          "statistics" => [],
          "teams" => %{
            "away" => %{
              "id" => 2278,
              "logo" => "https://media.api-sports.io/football/teams/2278.png",
              "name" => "Guadalajara Chivas",
              "winner" => nil
            },
            "home" => %{
              "id" => 2292,
              "logo" => "https://media.api-sports.io/football/teams/2292.png",
              "name" => "Pachuca",
              "winner" => nil
            }
          }
        }
      ]
    }
    {:ok, match}
  end

  def get_odds(_id) do
    odds = %{
      "errors" => [],
      "get" => "odds",
      "paging" => %{"current" => 1, "total" => 1},
      "parameters" => %{"fixture" => "1150340"},
      "response" => [
        %{
          "bookmakers" => [
            %{
              "bets" => [
                %{
                  "id" => 1,
                  "name" => "Match Winner",
                  "values" => [
                    %{"odd" => "2.20", "value" => "Home"},
                    %{"odd" => "3.50", "value" => "Draw"},
                    %{"odd" => "3.10", "value" => "Away"}
                  ]
                },
                %{
                  "id" => 2,
                  "name" => "Home/Away",
                  "values" => [
                    %{"odd" => "1.62", "value" => "Home"},
                    %{"odd" => "2.25", "value" => "Away"}
                  ]
                },
                %{
                  "id" => 3,
                  "name" => "Second Half Winner",
                  "values" => [
                    %{"odd" => "2.55", "value" => "Home"},
                    %{"odd" => "2.65", "value" => "Draw"},
                    %{"odd" => "3.25", "value" => "Away"}
                  ]
                }
              ],
              "id" => 27,
              "name" => "NordicBet"
            },
          ],
          "fixture" => %{
            "date" => "2024-04-13T23:00:00+00:00",
            "id" => 1150340,
            "timestamp" => 1713049200,
            "timezone" => "UTC"
          },
          "league" => %{
            "country" => "Mexico",
            "flag" => "https://media.api-sports.io/flags/mx.svg",
            "id" => 262,
            "logo" => "https://media.api-sports.io/football/leagues/262.png",
            "name" => "Liga MX",
            "season" => 2023
          },
          "update" => "2024-04-11T12:03:15+00:00"
        }
      ],
      "results" => 1
    }

    {:ok, odds}
  end

  def get_standings(_season, _league) do
    standings = %{
      "errors" => [],
      "get" => "standings",
      "paging" => %{"current" => 1, "total" => 1},
      "parameters" => %{"league" => "262", "season" => "2023"},
      "response" => [
        %{
          "league" => %{
            "country" => "Mexico",
            "flag" => "https://media.api-sports.io/flags/mx.svg",
            "id" => 262,
            "logo" => "https://media.api-sports.io/football/leagues/262.png",
            "name" => "Liga MX",
            "season" => 2023,
            "standings" => [
              [
                %{
                  "all" => %{
                    "draw" => 5,
                    "goals" => %{"against" => 16, "for" => 32},
                    "lose" => 1,
                    "played" => 14,
                    "win" => 8
                  },
                  "away" => %{
                    "draw" => 5,
                    "goals" => %{"against" => 12, "for" => 12},
                    "lose" => 1,
                    "played" => 7,
                    "win" => 1
                  },
                  "description" => "Final Series",
                  "form" => "WWWDW",
                  "goalsDiff" => 16,
                  "group" => "Liga MX: Clausura",
                  "home" => %{
                    "draw" => 0,
                    "goals" => %{"against" => 4, "for" => 20},
                    "lose" => 0,
                    "played" => 7,
                    "win" => 7
                  },
                  "points" => 29,
                  "rank" => 1,
                  "status" => "up",
                  "team" => %{
                    "id" => 2281,
                    "logo" => "https://media.api-sports.io/football/teams/2281.png",
                    "name" => "Toluca"
                  },
                  "update" => "2024-04-10T00:00:00+00:00"
                },
                %{
                  "all" => %{
                    "draw" => 5,
                    "goals" => %{"against" => 8, "for" => 22},
                    "lose" => 1,
                    "played" => 14,
                    "win" => 8
                  },
                  "away" => %{
                    "draw" => 3,
                    "goals" => %{"against" => 4, "for" => 12},
                    "lose" => 1,
                    "played" => 8,
                    "win" => 4
                  },
                  "description" => "Final Series",
                  "form" => "DWDWW",
                  "goalsDiff" => 14,
                  "group" => "Liga MX: Clausura",
                  "home" => %{
                    "draw" => 2,
                    "goals" => %{"against" => 4, "for" => 10},
                    "lose" => 0,
                    "played" => 6,
                    "win" => 4
                  },
                  "points" => 29,
                  "rank" => 2,
                  "status" => "same",
                  "team" => %{
                    "id" => 2287,
                    "logo" => "https://media.api-sports.io/football/teams/2287.png",
                    "name" => "Club America"
                  },
                  "update" => "2024-04-10T00:00:00+00:00"
                },
                %{
                  "all" => %{
                    "draw" => 4,
                    "goals" => %{"against" => 12, "for" => 24},
                    "lose" => 2,
                    "played" => 14,
                    "win" => 8
                  },
                  "away" => %{
                    "draw" => 2,
                    "goals" => %{"against" => 5, "for" => 10},
                    "lose" => 1,
                    "played" => 6,
                    "win" => 3
                  },
                  "description" => "Final Series",
                  "form" => "LLWWW",
                  "goalsDiff" => 12,
                  "group" => "Liga MX: Clausura",
                  "home" => %{
                    "draw" => 2,
                    "goals" => %{"against" => 7, "for" => 14},
                    "lose" => 1,
                    "played" => 8,
                    "win" => 5
                  },
                  "points" => 28,
                  "rank" => 3,
                  "status" => "down",
                  "team" => %{
                    "id" => 2282,
                    "logo" => "https://media.api-sports.io/football/teams/2282.png",
                    "name" => "Monterrey"
                  },
                  "update" => "2024-04-10T00:00:00+00:00"
                },
              ]
            ]
          }
        }
      ],
      "results" => 1
    }

    {:ok, standings}
  end

  def get_players(_id) do
    players = %{
      "errors" => [],
      "get" => "players",
      "paging" => %{"current" => 1, "total" => 3},
      "parameters" => %{"season" => "2023", "team" => "2292"},
      "response" => [
        %{
          "player" => %{
            "age" => 35,
            "birth" => %{
              "country" => "Venezuela",
              "date" => "1989-09-16",
              "place" => "Caracas"
            },
            "firstname" => "Jos├⌐ Salom├│n",
            "height" => "186 cm",
            "id" => 2461,
            "injured" => false,
            "lastname" => "Rond├│n Gim├⌐nez",
            "name" => "S. Rond├│n",
            "nationality" => "Venezuela",
            "photo" => "https://media.api-sports.io/football/players/2461.png",
            "weight" => "86 kg"
          },
          "statistics" => [
            %{
              "cards" => %{"red" => 0, "yellow" => 2, "yellowred" => 0},
              "dribbles" => %{"attempts" => 25, "past" => nil, "success" => 9},
              "duels" => %{"total" => 149, "won" => 61},
              "fouls" => %{"committed" => 19, "drawn" => 7},
              "games" => %{
                "appearences" => 13,
                "captain" => false,
                "lineups" => 11,
                "minutes" => 1047,
                "number" => nil,
                "position" => "Attacker",
                "rating" => "7.076923"
              },
              "goals" => %{
                "assists" => 2,
                "conceded" => 0,
                "saves" => nil,
                "total" => 7
              },
              "league" => %{
                "country" => "Mexico",
                "flag" => "https://media.api-sports.io/flags/mx.svg",
                "id" => 262,
                "logo" => "https://media.api-sports.io/football/leagues/262.png",
                "name" => "Liga MX",
                "season" => 2023
              },
              "passes" => %{"accuracy" => 13, "key" => 12, "total" => 243},
              "penalty" => %{
                "commited" => nil,
                "missed" => 0,
                "saved" => nil,
                "scored" => 2,
                "won" => nil
              },
              "shots" => %{"on" => 19, "total" => 40},
              "substitutes" => %{"bench" => 2, "in" => 2, "out" => 1},
              "tackles" => %{"blocks" => 2, "interceptions" => nil, "total" => 6},
              "team" => %{
                "id" => 2292,
                "logo" => "https://media.api-sports.io/football/teams/2292.png",
                "name" => "Pachuca"
              }
            }
          ]
        },
        %{
          "player" => %{
            "age" => 30,
            "birth" => %{
              "country" => "Ecuador",
              "date" => "1994-09-24",
              "place" => "Atuntaqui"
            },
            "firstname" => "Romario Andr├⌐s",
            "height" => "175 cm",
            "id" => 2585,
            "injured" => false,
            "lastname" => "Ibarra Mina",
            "name" => "Romario Ibarra",
            "nationality" => "Ecuador",
            "photo" => "https://media.api-sports.io/football/players/2585.png",
            "weight" => "73 kg"
          },
          "statistics" => [
            %{
              "cards" => %{"red" => 0, "yellow" => 0, "yellowred" => 0},
              "dribbles" => %{"attempts" => nil, "past" => nil, "success" => nil},
              "duels" => %{"total" => nil, "won" => nil},
              "fouls" => %{"committed" => nil, "drawn" => nil},
              "games" => %{
                "appearences" => 1,
                "captain" => false,
                "lineups" => 1,
                "minutes" => 57,
                "number" => nil,
                "position" => "Midfielder",
                "rating" => nil
              },
              "goals" => %{
                "assists" => nil,
                "conceded" => nil,
                "saves" => nil,
                "total" => 0
              },
              "league" => %{
                "country" => "World",
                "flag" => nil,
                "id" => 16,
                "logo" => "https://media.api-sports.io/football/leagues/16.png",
                "name" => "CONCACAF Champions League",
                "season" => 2023
              },
              "passes" => %{"accuracy" => nil, "key" => nil, "total" => nil},
              "penalty" => %{
                "commited" => nil,
                "missed" => nil,
                "saved" => nil,
                "scored" => nil,
                "won" => nil
              },
              "shots" => %{"on" => nil, "total" => nil},
              "substitutes" => %{"bench" => 0, "in" => 0, "out" => 1},
              "tackles" => %{
                "blocks" => nil,
                "interceptions" => nil,
                "total" => nil
              },
              "team" => %{
                "id" => 2292,
                "logo" => "https://media.api-sports.io/football/teams/2292.png",
                "name" => "Pachuca"
              }
            },
            %{
              "cards" => %{"red" => 0, "yellow" => 0, "yellowred" => 0},
              "dribbles" => %{"attempts" => nil, "past" => nil, "success" => nil},
              "duels" => %{"total" => nil, "won" => nil},
              "fouls" => %{"committed" => nil, "drawn" => nil},
              "games" => %{
                "appearences" => 0,
                "captain" => false,
                "lineups" => 0,
                "minutes" => 0,
                "number" => nil,
                "position" => "Midfielder",
                "rating" => nil
              },
              "goals" => %{
                "assists" => nil,
                "conceded" => nil,
                "saves" => nil,
                "total" => 0
              },
              "league" => %{
                "country" => "Mexico",
                "flag" => "https://media.api-sports.io/flags/mx.svg",
                "id" => 262,
                "logo" => "https://media.api-sports.io/football/leagues/262.png",
                "name" => "Liga MX",
                "season" => 2023
              },
              "passes" => %{"accuracy" => nil, "key" => nil, "total" => nil},
              "penalty" => %{
                "commited" => nil,
                "missed" => nil,
                "saved" => nil,
                "scored" => nil,
                "won" => nil
              },
              "shots" => %{"on" => nil, "total" => nil},
              "substitutes" => %{"bench" => 0, "in" => 0, "out" => 0},
              "tackles" => %{
                "blocks" => nil,
                "interceptions" => nil,
                "total" => nil
              },
              "team" => %{
                "id" => 2292,
                "logo" => "https://media.api-sports.io/football/teams/2292.png",
                "name" => "Pachuca"
              }
            }
          ]
        },
      ],
      "results" => 2
    }

    {:ok, players}
  end

  def get_past_fixtures(_id, _last) do
    past_fixtures = %{
      "errors" => [],
      "get" => "fixtures",
      "paging" => %{"current" => 1, "total" => 1},
      "parameters" => %{"last" => "5", "team" => "2292"},
      "response" => [
        %{
          "fixture" => %{
            "date" => "2024-04-11T00:15:00+00:00",
            "id" => 1184611,
            "periods" => %{"first" => 1712794500, "second" => 1712798100},
            "referee" => "Oshane Nation, Jamaica",
            "status" => %{
              "elapsed" => 90,
              "long" => "Match Finished",
              "short" => "FT"
            },
            "timestamp" => 1712794500,
            "timezone" => "UTC",
            "venue" => %{
              "city" => "Pachuca de Soto",
              "id" => 1081,
              "name" => "Estadio Hidalgo"
            }
          },
          "goals" => %{"away" => 1, "home" => 2},
          "league" => %{
            "country" => "World",
            "flag" => nil,
            "id" => 16,
            "logo" => "https://media.api-sports.io/football/leagues/16.png",
            "name" => "CONCACAF Champions League",
            "round" => "Quarter-finals",
            "season" => 2024
          },
          "score" => %{
            "extratime" => %{"away" => nil, "home" => nil},
            "fulltime" => %{"away" => 1, "home" => 2},
            "halftime" => %{"away" => 0, "home" => 0},
            "penalty" => %{"away" => nil, "home" => nil}
          },
          "teams" => %{
            "away" => %{
              "id" => 815,
              "logo" => "https://media.api-sports.io/football/teams/815.png",
              "name" => "CS Herediano",
              "winner" => false
            },
            "home" => %{
              "id" => 2292,
              "logo" => "https://media.api-sports.io/football/teams/2292.png",
              "name" => "Pachuca",
              "winner" => true
            }
          }
        },
        %{
          "fixture" => %{
            "date" => "2024-04-07T01:00:00+00:00",
            "id" => 1150332,
            "periods" => %{"first" => 1712451600, "second" => 1712455200},
            "referee" => "F. Hern├índez",
            "status" => %{
              "elapsed" => 90,
              "long" => "Match Finished",
              "short" => "FT"
            },
            "timestamp" => 1712451600,
            "timezone" => "UTC",
            "venue" => %{
              "city" => "San Nicol├ís de los Garza",
              "id" => 1087,
              "name" => "Estadio Universitario"
            }
          },
          "goals" => %{"away" => 3, "home" => 0},
          "league" => %{
            "country" => "Mexico",
            "flag" => "https://media.api-sports.io/flags/mx.svg",
            "id" => 262,
            "logo" => "https://media.api-sports.io/football/leagues/262.png",
            "name" => "Liga MX",
            "round" => "Clausura - 14",
            "season" => 2023
          },
          "score" => %{
            "extratime" => %{"away" => nil, "home" => nil},
            "fulltime" => %{"away" => 3, "home" => 0},
            "halftime" => %{"away" => 0, "home" => 0},
            "penalty" => %{"away" => nil, "home" => nil}
          },
          "teams" => %{
            "away" => %{
              "id" => 2292,
              "logo" => "https://media.api-sports.io/football/teams/2292.png",
              "name" => "Pachuca",
              "winner" => true
            },
            "home" => %{
              "id" => 2279,
              "logo" => "https://media.api-sports.io/football/teams/2279.png",
              "name" => "Tigres UANL",
              "winner" => false
            }
          }
        },
        %{
          "fixture" => %{
            "date" => "2024-04-04T02:00:00+00:00",
            "id" => 1184612,
            "periods" => %{"first" => 1712196000, "second" => 1712199600},
            "referee" => "Villarrea Armando, USA",
            "status" => %{
              "elapsed" => 90,
              "long" => "Match Finished",
              "short" => "FT"
            },
            "timestamp" => 1712196000,
            "timezone" => "UTC",
            "venue" => %{
              "city" => "San Jos├⌐",
              "id" => 392,
              "name" => "Estadio Nacional de Costa Rica"
            }
          },
          "goals" => %{"away" => 5, "home" => 0},
          "league" => %{
            "country" => "World",
            "flag" => nil,
            "id" => 16,
            "logo" => "https://media.api-sports.io/football/leagues/16.png",
            "name" => "CONCACAF Champions League",
            "round" => "Quarter-finals",
            "season" => 2024
          },
          "score" => %{
            "extratime" => %{"away" => nil, "home" => nil},
            "fulltime" => %{"away" => 5, "home" => 0},
            "halftime" => %{"away" => 2, "home" => 0},
            "penalty" => %{"away" => nil, "home" => nil}
          },
          "teams" => %{
            "away" => %{
              "id" => 2292,
              "logo" => "https://media.api-sports.io/football/teams/2292.png",
              "name" => "Pachuca",
              "winner" => true
            },
            "home" => %{
              "id" => 815,
              "logo" => "https://media.api-sports.io/football/teams/815.png",
              "name" => "CS Herediano",
              "winner" => false
            }
          }
        },
        %{
          "fixture" => %{
            "date" => "2024-03-31T01:00:00+00:00",
            "id" => 1150322,
            "periods" => %{"first" => 1711846800, "second" => 1711850400},
            "referee" => "D. Quintero",
            "status" => %{
              "elapsed" => 90,
              "long" => "Match Finished",
              "short" => "FT"
            },
            "timestamp" => 1711846800,
            "timezone" => "UTC",
            "venue" => %{
              "city" => "Pachuca de Soto",
              "id" => 1081,
              "name" => "Estadio Hidalgo"
            }
          },
          "goals" => %{"away" => 3, "home" => 2},
          "league" => %{
            "country" => "Mexico",
            "flag" => "https://media.api-sports.io/flags/mx.svg",
            "id" => 262,
            "logo" => "https://media.api-sports.io/football/leagues/262.png",
            "name" => "Liga MX",
            "round" => "Clausura - 13",
            "season" => 2023
          },
          "score" => %{
            "extratime" => %{"away" => nil, "home" => nil},
            "fulltime" => %{"away" => 3, "home" => 2},
            "halftime" => %{"away" => 3, "home" => 1},
            "penalty" => %{"away" => nil, "home" => nil}
          },
          "teams" => %{
            "away" => %{
              "id" => 2281,
              "logo" => "https://media.api-sports.io/football/teams/2281.png",
              "name" => "Toluca",
              "winner" => true
            },
            "home" => %{
              "id" => 2292,
              "logo" => "https://media.api-sports.io/football/teams/2292.png",
              "name" => "Pachuca",
              "winner" => false
            }
          }
        },
        %{
          "fixture" => %{
            "date" => "2024-03-18T01:00:00+00:00",
            "id" => 1150318,
            "periods" => %{"first" => 1710723600, "second" => 1710727200},
            "referee" => "V. C├íceres",
            "status" => %{
              "elapsed" => 90,
              "long" => "Match Finished",
              "short" => "FT"
            },
            "timestamp" => 1710723600,
            "timezone" => "UTC",
            "venue" => %{
              "city" => "San Luis Potos├¡",
              "id" => 1795,
              "name" => "Estadio Alfonso Lastras Ram├¡rez"
            }
          },
          "goals" => %{"away" => 1, "home" => 2},
          "league" => %{
            "country" => "Mexico",
            "flag" => "https://media.api-sports.io/flags/mx.svg",
            "id" => 262,
            "logo" => "https://media.api-sports.io/football/leagues/262.png",
            "name" => "Liga MX",
            "round" => "Clausura - 12",
            "season" => 2023
          },
          "score" => %{
            "extratime" => %{"away" => nil, "home" => nil},
            "fulltime" => %{"away" => 1, "home" => 2},
            "halftime" => %{"away" => 0, "home" => 1},
            "penalty" => %{"away" => nil, "home" => nil}
          },
          "teams" => %{
            "away" => %{
              "id" => 2292,
              "logo" => "https://media.api-sports.io/football/teams/2292.png",
              "name" => "Pachuca",
              "winner" => false
            },
            "home" => %{
              "id" => 2314,
              "logo" => "https://media.api-sports.io/football/teams/2314.png",
              "name" => "Atletico San Luis",
              "winner" => true
            }
          }
        }
      ],
      "results" => 5
    }

    {:ok, past_fixtures}
  end

  # defp handle_response({:ok, %{body: body, status_code: 200}}) do
  #   {:ok, Poison.decode!(body)}
  # end

  # defp handle_response({:ok, %{status_code: _status, body: body}}) do
  #   message =
  #     Poison.Parser.parse!(body)
  #     |> get_in(["message"])
  #   {:error, message}
  # end

  # defp handle_response({:error, %{reason: reason}}) do
  #   {:error, reason}
  # end
end
