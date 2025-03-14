defmodule ExpenseTrackerWeb.ExpenseLiveTest do
  use ExpenseTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExpenseTracker.ExpensesFixtures

  @create_attrs %{name: "some name", description: "some description", category: "some category", account_type: "some account_type", amount: 120.5}
  @update_attrs %{name: "some updated name", description: "some updated description", category: "some updated category", account_type: "some updated account_type", amount: 456.7}
  @invalid_attrs %{name: nil, description: nil, category: nil, account_type: nil, amount: nil}

  defp create_expense(_) do
    expense = expense_fixture()
    %{expense: expense}
  end

  describe "Index" do
    setup [:create_expense]

    test "lists all expenses", %{conn: conn, expense: expense} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Listing Expenses"
      assert html =~ expense.name
    end

    test "saves new expense", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("a", "New Expense") |> render_click() =~
               "New Expense"

      assert_patch(index_live, ~p"/new")

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#expense-form", expense: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Expense created successfully"
      assert html =~ "some name"
    end

    test "updates expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("#expenses-#{expense.id} a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(index_live, ~p"/#{expense}/edit")

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#expense-form", expense: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Expense updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("#expenses-#{expense.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#expenses-#{expense.id}")
    end
  end

  describe "Show" do
    setup [:create_expense]

    test "displays expense", %{conn: conn, expense: expense} do
      {:ok, _show_live, html} = live(conn, ~p"/#{expense}")

      assert html =~ "Show Expense"
      assert html =~ expense.name
    end

    test "updates expense within modal", %{conn: conn, expense: expense} do
      {:ok, show_live, _html} = live(conn, ~p"/#{expense}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(show_live, ~p"/#{expense}/show/edit")

      assert show_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#expense-form", expense: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/#{expense}")

      html = render(show_live)
      assert html =~ "Expense updated successfully"
      assert html =~ "some updated name"
    end
  end
end
