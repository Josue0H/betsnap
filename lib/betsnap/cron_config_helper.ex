defmodule Betsnap.CronConfigHelper do
  def get do
    [
      crontab: [
        {"*/15 * * * *", Betsnap.Workers.ProcessorWorker, args: %{name: "ProcessorWorker"}}
      ]
    ]
  end
end
