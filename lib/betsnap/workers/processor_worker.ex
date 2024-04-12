defmodule Betsnap.Workers.ProcessorWorker do
  use Oban.Worker, queue: :bets_validation

  alias Betsnap.Bets

  def perform(_job) do
    IO.puts("Processing job...")
    Bets.validate_all_bets()
    IO.puts("Job finished!")
  end
end
