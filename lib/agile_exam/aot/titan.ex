defmodule AgileExam.Aot.Titan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "titans" do
    field :name, :string
    field :power, :float
    field :is_special, :boolean, default: false

    timestamps()
  end

  def changeset(titan, attrs) do
    titan
    |> cast(attrs, [:name, :power, :is_special])
    |> validate_required([:name, :power])
    |> require_param(:is_special, attrs)
    |> validate_number(:power, greater_than: 0.0, less_than_or_equal_to: 100.0)
    |> validate_inclusion(:is_special, [true, false])
    |> unique_constraint(:name)
    |> check_constraint(:power, name: :titans_power_range)
  end

  defp require_param(changeset, key, attrs) when is_map(attrs) do
    if Map.has_key?(attrs, key) or Map.has_key?(attrs, Atom.to_string(key)) do
      changeset
    else
      Ecto.Changeset.add_error(changeset, key, "can't be blank")
    end
  end
end
