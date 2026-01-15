defmodule AgileExamWeb.AttackControllerTest do
  use AgileExamWeb.ConnCase

  alias AgileExam.Repo
  alias AgileExam.Aot.{Titan, StudentSquad}

  describe "POST /simulate_attack - pyrrhic victory scenario" do
    test "simulation ends in pyrrhic victory with equal powers, deletes titans, deactivates squads",
         %{conn: conn} do
      # Step 1: Insert data that results in a pyrrhic victory (titan_power == student_power)
      #
      # Titan power calculation: power * (is_special ? 2.5 : 1.0)
      # Student power calculation: sum of (num_members * weight) for active squads
      #   where weight = scout: 20, garrison: 15, police: 1
      #
      # We'll create:
      # - 1 titan with power=100, is_special=false -> titan_power = 100
      # - 1 active scout squad with 5 members -> student_power = 5 * 20 = 100
      # This gives equal power -> pyrrhic victory!

      # Insert titan
      titan =
        Repo.insert!(%Titan{
          name: "Test Titan",
          power: 100.0,
          is_special: false
        })

      # Insert active scout squad (required for pyrrhic victory, otherwise it's defeat)
      squad =
        Repo.insert!(%StudentSquad{
          name: "Test Scout Squad",
          num_members: 5,
          group: "scout",
          state: true
        })

      # Verify data was inserted correctly
      assert Repo.get!(Titan, titan.id)
      assert Repo.get!(StudentSquad, squad.id)

      # Step 2: Perform the simulation by making a POST request
      conn = post(conn, ~p"/simulate_attack")

      # Step 3: Validate the three expected consequences

      # 3a: Assert the response contains the pyrrhic victory message
      assert html_response(conn, 200) =~ "Pyrrhic Victory! Both sides are exhausted."

      # 3b: Assert all titans have been deleted from the database
      titans_after = Repo.all(Titan)
      assert titans_after == [], "Expected all titans to be deleted after pyrrhic victory"

      # 3c: Assert all student squads are now inactive (state = false)
      squads_after = Repo.all(StudentSquad)
      assert length(squads_after) == 1, "Expected student squad to still exist"

      updated_squad = hd(squads_after)

      assert updated_squad.state == false,
             "Expected student squad to be inactive after pyrrhic victory"

      assert updated_squad.id == squad.id, "Expected the same squad to exist"
    end

    test "simulation shows pyrrhic victory message in result div", %{conn: conn} do
      # Setup data for pyrrhic victory with multiple squads
      # Total titan power = 40 * 2.5 = 100 (special titan)
      # Total student power = 100 (1 active scout with 5 members: 5 * 20 = 100)

      Repo.insert!(%Titan{
        name: "Special Titan",
        power: 40.0,
        is_special: true
      })

      Repo.insert!(%StudentSquad{
        name: "Scout Team",
        num_members: 5,
        group: "scout",
        state: true
      })

      conn = post(conn, ~p"/simulate_attack")

      # Assert the page contains the result
      response = html_response(conn, 200)
      assert response =~ "Pyrrhic Victory!"
      assert response =~ "Both sides are exhausted"
      assert response =~ "id=\"result\""
    end
  end
end
