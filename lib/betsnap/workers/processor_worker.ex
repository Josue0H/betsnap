defmodule Betsnap.Workers.ProcessorWorker do
  @moduledoc """
  Module to handle the processor worker
  """

  use Oban.Worker, queue: :bets_validation

  alias Betsnap.Bets

  def perform(_job) do
    IO.puts("Processing job...")
    Bets.validate_all_bets()
    IO.puts("Job finished!")
  end
end
