defmodule AgileExamWeb.TitanController do
  use AgileExamWeb, :controller

  alias AgileExam.Aot
  alias AgileExam.Aot.Titan

  def index(conn, _params) do
    titans = Aot.list_titans()
    render(conn, :index, titans: titans)
  end

  def new(conn, _params) do
    changeset = Aot.change_titan(%Titan{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"titan" => titan_params}) do
    case Aot.create_titan(titan_params) do
      {:ok, _titan} ->
        conn
        |> put_flash(:info, "Titan created successfully.")
        |> redirect(to: ~p"/titans")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
