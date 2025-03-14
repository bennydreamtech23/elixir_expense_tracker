defmodule ExpenseTracker.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :name, :string
    field :description, :string
    field :category, :string
    field :account_type, :string
    field :amount, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:name, :description, :category, :account_type, :amount])
    |> validate_required([:name, :description, :category, :account_type, :amount])
  end
end
