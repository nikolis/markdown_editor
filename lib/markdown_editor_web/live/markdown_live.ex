defmodule MarkdownEditorWeb.MarkdownLive do
  use MarkdownEditorWeb, :live_view
  alias Phoenix.LiveView.JS

  def mount(_params, _session, socket) do
    form = to_form(%{markdown: ""})
    {:ok, 
      assign(socket, markdown: "", rendered_html: "")
      |> assign(form: form)
    }
  end

  def handle_event("update_markdown", %{"markdown" => md}, socket) do
    IO.inspect(md, label: "Here in the markdown")
    html = Earmark.as_html!(md || "")
    form = to_form(%{markdown: md})
    {:noreply, assign(socket, markdown: md, rendered_html: html)}
  end

  def handle_event("export_pdf", _, socket) do
    html = socket.assigns.rendered_html
    filename = "export.pdf"
    {:ok, path} = PdfGenerator.generate(html, page_size: "A4", filename: filename)

    {:noreply,
     push_event(socket, "download", %{url: Routes.static_path(socket, "/pdfs/" <> filename)})}
  end
end

