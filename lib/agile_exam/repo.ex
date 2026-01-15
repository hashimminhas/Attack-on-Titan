defmodule AgileExam.Repo do
  use Ecto.Repo,
    otp_app: :agile_exam,
    adapter: Ecto.Adapters.Postgres
end
