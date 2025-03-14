defmodule ExpenseTrackerWeb.ExpenseLive.FormComponent do
  use ExpenseTrackerWeb, :live_component

  alias ExpenseTracker.Expenses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Create a new expenses</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="expense-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
      <.input
  field={@form[:account_type]}
  type="select"
  label="Account Type"
  options={[{"Debit", "debit"}, {"Credit", "credit"}]}
  required
/>
        <.input field={@form[:name]} type="text" label="Name" required />
        <.input field={@form[:description]} type="text" label="Description"  />
        <.input
  field={@form[:category]}
  type="select"
  label="Category"
  options={[{"Fashion", "fashion"}, {"Foodstuff", "foodsfuff"}, {"Salary", "salary"}, {"gift", "gift"}]}
  required
/>


        <.input field={@form[:amount]} type="number" label="Amount" step="any" required/>
        <:actions>
          <.button phx-disable-with="Saving...">Save Expense</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{expense: expense} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Expenses.change_expense(expense))
     end)}
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    changeset = Expenses.change_expense(socket.assigns.expense, expense_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"expense" => expense_params}, socket) do
    save_expense(socket, socket.assigns.action, expense_params)
  end

  defp save_expense(socket, :edit, expense_params) do
    case Expenses.update_expense(socket.assigns.expense, expense_params) do
      {:ok, expense} ->
        notify_parent({:saved, expense})

        {:noreply,
         socket
         |> put_flash(:info, "Expense updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_expense(socket, :new, expense_params) do
    case Expenses.create_expense(expense_params) do
      {:ok, expense} ->
        notify_parent({:saved, expense})

        {:noreply,
         socket
         |> put_flash(:info, "Expense created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
