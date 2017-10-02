defmodule WippliBackendWeb.ErrorView do
  use WippliBackendWeb, :view

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "error.json", assigns
  end

  def translate_reason(reason) do
    case reason.status do
      :not_found -> "Page not found"
      :unauthorized -> "Unauthorized: #{reason.message}"
      :forbidden -> "Action forbidden: #{reason.message}"
      :internal_server_error -> "Internal server error: #{reason.message}"
      _ -> "Something went wrong"
    end
  end

  def render("error.json", %{reason: reason}) do
    %{errors: translate_reason(reason),
      status: reason.status}
  end

end
