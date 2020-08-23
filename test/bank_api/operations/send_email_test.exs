defmodule BankApi.SendEmailTest do

use ExUnit.Case

alias BankApi.SendEmail

test "send email when withdrawal is successful" do
  SendEmail.run()
end
end
