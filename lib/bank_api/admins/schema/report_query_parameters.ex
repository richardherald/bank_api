defmodule ApiBanking.Admins.Schema.ReportQueryParameters do
  @moduledoc """
    Report Query Parameters
  """
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :filter_by, :string
    field :date, :date
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:filter_by, :date])
    |> validate_inclusion(:filter_by, filter_types(),
      message: "filter_by invalid. Chosse one of the options: day, month, year or total"
    )
  end

  defp filter_types do
    ["day", "month", "year", "total"]
  end
end
