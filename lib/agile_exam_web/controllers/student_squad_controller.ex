defmodule AgileExamWeb.StudentSquadController do
  use AgileExamWeb, :controller

  alias AgileExam.Aot
  alias AgileExam.Aot.StudentSquad

  def index(conn, _params) do
    squads = Aot.list_student_squads()
    render(conn, :index, squads: squads)
  end

  def new(conn, _params) do
    changeset = Aot.change_student_squad(%StudentSquad{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"student_squad" => squad_params}) do
    case Aot.create_student_squad(squad_params) do
      {:ok, _squad} ->
        conn
        |> put_flash(:info, "Student squad created successfully.")
        |> redirect(to: ~p"/student_squads")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
