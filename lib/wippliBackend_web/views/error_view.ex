defmodule WippliBackendWeb.ErrorView do
  use WippliBackendWeb, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  def render("400.json", %{message: message}) do
    %{errors: %{detail: "Unauthorized",  reason: message}}
  end
  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end

  def translate_reason(reason) do
    case reason.status do
      :forbidden -> "Action forbbiden: #{reason.message}"
      :internal_server_error -> "Internal server error: #{reason.message}"
    end
  end

  def render("error.json", %{reason: reason}) do
    %{errors: translate_reason(reason)}
  end

end
