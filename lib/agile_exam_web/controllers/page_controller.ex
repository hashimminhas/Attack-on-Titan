defmodule AgileExamWeb.PageController do
  use AgileExamWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def name(conn, _params) do
    render(conn, :name, layout: false)
  end
end
