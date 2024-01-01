defmodule Exchangy.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Exchangy.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias Exchangy.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Exchangy.DataCase
      import Exchangy.Factory
    end
  end

  setup tags do
    Exchangy.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Sandbox.start_owner!(Exchangy.Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  @doc """
  A helper to compare Ecto structs by their primary fields (ignoring associations) 
  """
  def ecto_schema_primary_fields_equal?(struct1, struct2) do
    schema_module = struct1.__struct__

    schema_module.__schema__(:fields)
    |> Enum.each(fn field ->
      assert Map.get(struct1, field) ==
               Map.get(struct2, field),
             "Expected #{inspect(Map.get(struct1, field))} to equal #{inspect(Map.get(struct2, field))}"
    end)
  end
end
