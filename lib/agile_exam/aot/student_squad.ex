defmodule AgileExam.Aot.StudentSquad do
  use Ecto.Schema
  import Ecto.Changeset

  @groups ~w(scout garrison police)

  schema "student_squads" do
    field :name, :string
    field :num_members, :integer
    field :group, :string
    field :state, :boolean, default: true

    timestamps()
  end

  def changeset(squad, attrs) do
    squad
    |> cast(attrs, [:name, :num_members, :group, :state])
    |> validate_required([:name, :num_members, :group])
    |> require_param(:state, attrs)
    |> validate_number(:num_members, greater_than_or_equal_to: 1, less_than_or_equal_to: 8)
    |> validate_inclusion(:group, @groups)
    |> validate_inclusion(:state, [true, false])
    |> unique_constraint(:name)
    |> check_constraint(:num_members, name: :student_squads_num_members_range)
    |> check_constraint(:group, name: :student_squads_group_allowed)
  end

  defp require_param(changeset, key, attrs) when is_map(attrs) do
    if Map.has_key?(attrs, key) or Map.has_key?(attrs, Atom.to_string(key)) do
      changeset
    else
      Ecto.Changeset.add_error(changeset, key, "can't be blank")
    end
  end
end
