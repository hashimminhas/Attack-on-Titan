defmodule AgileExam.Aot.TitanChangesetTest do
  use AgileExam.DataCase, async: true

  alias AgileExam.Aot.Titan

  test "valid titan changeset" do
    cs =
      Titan.changeset(%Titan{}, %{
        name: "Armored",
        power: 60.0,
        is_special: true
      })

    assert cs.valid?
  end

  test "requires all fields" do
    cs = Titan.changeset(%Titan{}, %{})
    refute cs.valid?

    assert %{
             name: ["can't be blank"],
             power: ["can't be blank"],
             is_special: ["can't be blank"]
           } = errors_on(cs)
  end

  test "power must be > 0.0 and <= 100.0" do
    cs1 = Titan.changeset(%Titan{}, %{name: "T1", power: 0.0, is_special: false})
    refute cs1.valid?
    assert %{power: [_ | _]} = errors_on(cs1)

    cs2 = Titan.changeset(%Titan{}, %{name: "T2", power: 101.0, is_special: false})
    refute cs2.valid?
    assert %{power: [_ | _]} = errors_on(cs2)

    cs3 = Titan.changeset(%Titan{}, %{name: "T3", power: 100.0, is_special: false})
    assert cs3.valid?
  end
end
