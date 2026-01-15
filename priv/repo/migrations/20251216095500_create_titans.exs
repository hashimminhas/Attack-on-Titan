defmodule AgileExam.Repo.Migrations.CreateTitans do
  use Ecto.Migration

  def change do
    create table(:titans) do
      add :name, :string, null: false
      add :power, :float, null: false
      add :is_special, :boolean, null: false, default: false

      timestamps()
    end

    create unique_index(:titans, [:name])

    # 0.00 excluded, 100.00 included
    create constraint(:titans, :titans_power_range, check: "power > 0.0 AND power <= 100.0")
  end
end
