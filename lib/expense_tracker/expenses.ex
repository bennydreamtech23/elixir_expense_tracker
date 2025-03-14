defmodule ExpenseTracker.Expenses do
  @moduledoc """
  The Expenses context.
  """

  import Ecto.Query, warn: false
  alias ExpenseTracker.Repo

  alias ExpenseTracker.Expenses.Expense

  @doc """
  Returns the list of expenses.

  ## Examples

      iex> list_expenses()
      [%Expense{}, ...]

  """
  def list_expenses do
    Repo.all(Expense)
  end

  @doc """
  Gets a single expense.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id), do: Repo.get!(Expense, id)

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end


  def total_monthly_debit do
    monthly_debit_query =
      from(e in Expense,
        where: e.account_type == "debit",
        group_by: fragment("date_trunc('month', ?)", e.inserted_at),
        select: %{
          month: fragment("TO_CHAR(date_trunc('month', ?), 'YYYY-MM')", e.inserted_at),
          total_debit: sum(e.amount)
        },
        order_by: fragment("date_trunc('month', ?)", e.inserted_at)
      )

    result = Repo.one(monthly_debit_query)
    IO.inspect(result, label: "total debit") # Debugging output

    result
  end


  def total_monthly_credit do
    monthly_credit_query =
      from(e in Expense,
        where: e.account_type == "credit",
        group_by: fragment("date_trunc('month', ?)", e.inserted_at),
        select: %{
          month: fragment("TO_CHAR(date_trunc('month', ?), 'YYYY-MM')", e.inserted_at),
          total_credit: sum(e.amount)
        },
        order_by: fragment("date_trunc('month', ?)", e.inserted_at)
      )

    result = Repo.one(monthly_credit_query)
    IO.inspect(result, label: "total debit") # Debugging output

    result
  end






  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end
end
