defmodule ExpenseTrackerWeb.ExpenseLive.Index do
  use ExpenseTrackerWeb, :live_view

  alias ExpenseTracker.Expenses
  alias ExpenseTracker.Expenses.Expense
  import Number.Delimit

  @impl true
  def mount(_params, _session, socket) do


    total_debit = Expenses.total_monthly_debit.total_debit || 0.00
    total_credit = Expenses.total_monthly_credit.total_credit || 0.00
    date =  Expenses.total_monthly_credit.month
    balance = total_credit - total_debit

    socket =
    socket
    |> stream(:expenses, Expenses.list_expenses())
    |> assign(:total_debit, total_debit)
    |> assign(:total_credit, total_credit)
    |> assign(:date, date)
    |> assign(:balance, balance)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Expense")
    |> assign(:expense, Expenses.get_expense!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Expense{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Expenses")
    |> assign(:expense, nil)
  end

  @impl true
  def handle_info({ExpenseTrackerWeb.ExpenseLive.FormComponent, {:saved, expense}}, socket) do
    {:noreply, stream_insert(socket, :expenses, expense)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    expense = Expenses.get_expense!(id)
    {:ok, _} = Expenses.delete_expense(expense)

    {:noreply, stream_delete(socket, :expenses, expense)}
  end
end
