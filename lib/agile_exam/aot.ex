defmodule AgileExam.Aot do
  alias AgileExam.Repo

  alias AgileExam.Aot.{Titan, StudentSquad}

  # -----------------
  # R1: Titans
  # -----------------
  def list_titans, do: Repo.all(Titan)

  def change_titan(%Titan{} = titan, attrs \\ %{}),
    do: Titan.changeset(titan, attrs)

  def create_titan(attrs) when is_map(attrs) do
    %Titan{}
    |> Titan.changeset(attrs)
    |> Repo.insert()
  end

  # -----------------
  # R1: Student squads
  # -----------------
  def list_student_squads, do: Repo.all(StudentSquad)

  def change_student_squad(%StudentSquad{} = squad, attrs \\ %{}),
    do: StudentSquad.changeset(squad, attrs)

  def create_student_squad(attrs) when is_map(attrs) do
    %StudentSquad{}
    |> StudentSquad.changeset(attrs)
    |> Repo.insert()
  end

  # -----------------
  # R2: Simulate attack
  # -----------------
  def simulate_attack do
    titans = Repo.all(Titan)

    if titans == [] do
      {:no_titans, "The attack cannot happen. There are no Titans."}
    else
      squads = Repo.all(StudentSquad)

      has_active_scout =
        Enum.any?(squads, fn s -> s.state == true and s.group == "scout" end)

      if not has_active_scout do
        Repo.update_all(StudentSquad, set: [state: false])
        {:absolute_defeat, "Defeat! The Titans have won."}
      else
        titan_power = total_titan_power(titans)
        student_power = total_student_power(squads)

        cond do
          titan_power > student_power ->
            Repo.update_all(StudentSquad, set: [state: false])
            {:defeat, "Defeat! The Titans have won."}

          titan_power == student_power ->
            Repo.transaction(fn ->
              Repo.update_all(StudentSquad, set: [state: false])
              Repo.delete_all(Titan)
            end)

            {:pyrrhic_victory, "Pyrrhic Victory! Both sides are exhausted."}

          true ->
            Repo.delete_all(Titan)
            {:victory, "Victory! The Students have won."}
        end
      end
    end
  end

  defp total_titan_power(titans) do
    Enum.reduce(titans, 0.0, fn t, acc ->
      mult = if t.is_special, do: 2.5, else: 1.0
      acc + t.power * mult
    end)
  end

  defp total_student_power(squads) do
    Enum.reduce(squads, 0.0, fn s, acc ->
      if s.state do
        weight =
          case s.group do
            "scout" -> 20
            "garrison" -> 15
            "police" -> 1
          end

        acc + s.num_members * weight
      else
        acc
      end
    end)
  end
end
