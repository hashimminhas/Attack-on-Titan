defmodule AgileExam.Repo.Migrations.CreateStudentSquads do
  use Ecto.Migration

  def change do
    create table(:student_squads) do
      add :name, :string, null: false
      add :num_members, :integer, null: false
      add :group, :string, null: false
      add :state, :boolean, null: false, default: true

      timestamps()
    end

    create unique_index(:student_squads, [:name])

    create constraint(:student_squads, :student_squads_num_members_range,
             check: "num_members >= 1 AND num_members <= 8"
           )

    # group is a keyword in SQL, but Postgres allows it as an identifier; Ecto will quote it.
    create constraint(:student_squads, :student_squads_group_allowed,
             check: "\"group\" IN ('scout', 'garrison', 'police')"
           )
  end
end
