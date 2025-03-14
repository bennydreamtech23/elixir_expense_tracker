defmodule ExpenseTracker.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExpenseTracker.Expenses` context.
  """

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        account_type: "some account_type",
        amount: 120.5,
        category: "some category",
        description: "some description",
        name: "some name"
      })
      |> ExpenseTracker.Expenses.create_expense()

    expense
  end
end
