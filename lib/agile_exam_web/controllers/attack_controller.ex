defmodule AgileExamWeb.AttackController do
  use AgileExamWeb, :controller

  alias AgileExam.Aot

  def new(conn, _params) do
    render(conn, :new, result: nil)
  end

  def create(conn, _params) do
    {_status, message} = Aot.simulate_attack()
    render(conn, :new, result: message)
  end
end
