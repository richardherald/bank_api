defmodule BankApi.SendEmail do
  @moduledoc """
  SendEmail module
  """

  def run do
    :timer.sleep(4000)
    IO.puts("Email sent")
  end
end
