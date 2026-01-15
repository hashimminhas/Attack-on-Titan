defmodule AgileExam.Aot.StudentSquadChangesetTest do
  use AgileExam.DataCase, async: true

  alias AgileExam.Aot.StudentSquad

  test "valid student squad changeset" do
    cs =
      StudentSquad.changeset(%StudentSquad{}, %{
        name: "Hange",
        num_members: 6,
        group: "scout",
        state: true
      })

    assert cs.valid?
  end

  test "requires all fields" do
    cs = StudentSquad.changeset(%StudentSquad{}, %{})
    refute cs.valid?

    assert %{
             name: ["can't be blank"],
             num_members: ["can't be blank"],
             group: ["can't be blank"],
             state: ["can't be blank"]
           } = errors_on(cs)
  end

  test "num_members must be between 1 and 8" do
    cs1 =
      StudentSquad.changeset(%StudentSquad{}, %{
        name: "S1",
        num_members: 0,
        group: "scout",
        state: true
      })

    refute cs1.valid?
    assert %{num_members: [_ | _]} = errors_on(cs1)

    cs2 =
      StudentSquad.changeset(%StudentSquad{}, %{
        name: "S2",
        num_members: 9,
        group: "scout",
        state: true
      })

    refute cs2.valid?
    assert %{num_members: [_ | _]} = errors_on(cs2)
  end

  test "group must be scout, garrison, or police" do
    cs =
      StudentSquad.changeset(%StudentSquad{}, %{
        name: "S3",
        num_members: 4,
        group: "random",
        state: true
      })

    refute cs.valid?
    assert %{group: [_ | _]} = errors_on(cs)
  end
end
