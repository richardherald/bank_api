defmodule BankApi.SendEmail do
  @moduledoc """
  SendEmail module
  """

  def run do
    :timer.sleep(1000)
    IO.puts("Email sent")
  end
end
