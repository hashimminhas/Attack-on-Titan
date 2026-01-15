defmodule AttackSimulationContext do
  use WhiteBread.Context
  use Hound.Helpers

  alias AgileExam.Repo

  @simulate_attack_path "/simulate_attack"

  # ----------------------------
  # GIVEN: seed DB from tables
  # ----------------------------

  given_ "the following titans are in the database", fn state, table ->
    ensure_db_checked_out!()
    rows = normalize_table(table)

    # NOTE: These table/column names must match your migrations later:
    # titans(name, power, is_special, inserted_at, updated_at)
    Repo.query!("DELETE FROM titans", [])

    Enum.each(rows, fn row ->
      name = fetch!(row, "name")
      power = fetch_float!(row, "power")
      is_special = fetch_bool!(row, "is_special")

      Repo.query!(
        """
        INSERT INTO titans (name, power, is_special, inserted_at, updated_at)
        VALUES ($1, $2, $3, NOW(), NOW())
        """,
        [name, power, is_special]
      )
    end)

    {:ok, state}
  end

  given_ "the following student squads are in the database", fn state, table ->
    ensure_db_checked_out!()
    rows = normalize_table(table)

    # student_squads(name, num_members, group, state, inserted_at, updated_at)
    Repo.query!("DELETE FROM student_squads", [])

    Enum.each(rows, fn row ->
      name = fetch!(row, "name")
      num_members = fetch_int!(row, "num_members")
      group = fetch!(row, "group")
      state_bool = fetch_state_bool!(row, "state") # "active"/"inactive" -> boolean

      Repo.query!(
        """
        INSERT INTO student_squads (name, num_members, "group", state, inserted_at, updated_at)
        VALUES ($1, $2, $3, $4, NOW(), NOW())
        """,
        [name, num_members, group, state_bool]
      )
    end)

    {:ok, state}
  end

  # ----------------------------
  # WHEN: browser navigation
  # ----------------------------

  when_ ~r/^I navigate to the "(?<page>[^"]+)" page$/, fn state, %{page: page} ->
    ensure_phoenix_server_running!()
    ensure_hound_session_started!()

    path =
      case String.downcase(page) do
        "simulate attack" -> @simulate_attack_path
        other -> raise "Unknown page name in feature: #{inspect(other)}"
      end

    navigate_to(base_url() <> path)
    {:ok, state}
  end

  when_ ~r/^I click on the "(?<label>[^"]+)" button$/, fn state, %{label: label} ->
    ensure_hound_session_started!()

    click_button_by_label!(label)
    {:ok, state}
  end

  # ----------------------------
  # THEN: assert result text
  # ----------------------------

  then_ ~r/^I can see on the page the result is "(?<msg>[^"]+)"$/, fn state, %{msg: msg} ->
    ensure_hound_session_started!()

    assert String.contains?(page_source(), msg)
    {:ok, state}
  end

  # ----------------------------
  # Helpers
  # ----------------------------

  defp ensure_db_checked_out! do
    # WhiteBread is not automatically a ConnCase/DataCase, so we must checkout manually.
    # This keeps DB access deterministic under test pool.
    case Ecto.Adapters.SQL.Sandbox.checkout(Repo) do
      :ok -> :ok
      {:already, :owner} -> :ok
      other -> raise "Sandbox checkout failed: #{inspect(other)}"
    end
  end

  defp ensure_hound_session_started! do
    # If your demo already starts sessions elsewhere, this is still safe-ish.
    # It will error if a session is already running; so we guard with rescue.
    try do
      Application.ensure_all_started(:hound)
      # For browser tests with DB sandbox, we need to encode metadata in user agent
      metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Repo, self())
      ua = Phoenix.Ecto.SQL.Sandbox.encode_metadata(metadata)
      Hound.start_session(user_agent: ua)
    rescue
      _ -> :ok
    end
  end

  defp ensure_phoenix_server_running! do
    # IMPORTANT:
    # For browser tests Phoenix must run a real HTTP server in test env.
    # The standard approach is setting `server: true` in config/test.exs.
    #
    # Here we simply ensure the app is started. The config is handled in test.exs.
    Application.ensure_all_started(:agile_exam)
  end

  defp base_url do
    http = AgileExamWeb.Endpoint.config(:http) || []
    port = Keyword.get(http, :port, 4002)
    "http://localhost:#{port}"
  end

  defp click_button_by_label!(label) do
    wanted = normalize_ws(String.downcase(label))

    # Grab common button types and match by visible text or value attr. :contentReference[oaicite:3]{index=3}
    candidates =
      find_all_elements(:css, "button, input[type='submit'], input[type='button']")

    button =
      Enum.find(candidates, fn el ->
        text = el |> visible_text() |> to_string() |> String.downcase() |> normalize_ws()
        value = el |> attribute_value("value") |> to_string() |> String.downcase() |> normalize_ws()
        text == wanted or value == wanted
      end)

    if is_nil(button) do
      raise "Could not find a button with label #{inspect(label)}"
    end

    click(button)
  end

defp normalize_table({:table_data, rows}) when is_list(rows) do
  Enum.map(rows, fn row ->
    row
    |> Enum.map(fn {k, v} -> {to_string(k), to_string(v)} end)
    |> Map.new()
  end)
end

defp normalize_table(%{table_data: rows}) when is_list(rows), do: normalize_table({:table_data, rows})
defp normalize_table(%{"table_data" => rows}) when is_list(rows), do: normalize_table({:table_data, rows})

defp normalize_table(table) do
  cond do
    is_list(table) and table != [] and is_list(hd(table)) ->
      [headers | rows] = table
      headers = Enum.map(headers, &to_string/1)

      Enum.map(rows, fn row ->
        headers
        |> Enum.zip(Enum.map(row, &to_string/1))
        |> Map.new()
      end)

    is_list(table) and table != [] and is_map(hd(table)) ->
      Enum.map(table, fn row ->
        row
        |> Enum.map(fn {k, v} -> {to_string(k), to_string(v)} end)
        |> Map.new()
      end)

    true ->
      raise "Unexpected WhiteBread table format: #{inspect(table)}"
  end
end


 defp fetch!(row, key) do
  case Map.fetch(row, key) do
    {:ok, v} ->
      v = v |> to_string() |> String.trim()

      if v == "" do
        raise "Empty value for required column #{inspect(key)} in row: #{inspect(row)}"
      end

      v

    :error ->
      raise "Missing required column #{inspect(key)} in row: #{inspect(row)}"
  end
end


  defp fetch_int!(row, key) do
    v = fetch!(row, key)
    case Integer.parse(v) do
      {i, ""} -> i
      _ -> raise "Expected integer for #{key}, got: #{inspect(v)}"
    end
  end

  defp fetch_float!(row, key) do
    v = fetch!(row, key)

    case Float.parse(v) do
      {f, ""} -> f
      _ ->
        # allow "60" to parse as float
        case Integer.parse(v) do
          {i, ""} -> i * 1.0
          _ -> raise "Expected float for #{key}, got: #{inspect(v)}"
        end
    end
  end

  defp fetch_bool!(row, key) do
    v = row |> fetch!(key) |> String.downcase()

    case v do
      "true" -> true
      "false" -> false
      _ -> raise "Expected boolean (true/false) for #{key}, got: #{inspect(v)}"
    end
  end

  defp fetch_state_bool!(row, key) do
    v = row |> fetch!(key) |> String.downcase()

    case v do
      "active" -> true
      "inactive" -> false
      _ -> raise "Expected state (active/inactive) for #{key}, got: #{inspect(v)}"
    end
  end

  defp normalize_ws(s), do: s |> String.replace(~r/\s+/, " ") |> String.trim()
end
