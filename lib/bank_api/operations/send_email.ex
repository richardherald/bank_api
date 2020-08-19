defmodule BankApi.SendEmail do
  def run() do
    :timer.sleep(4000)
    IO.puts("Email sent")
  end
end
