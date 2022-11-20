defmodule FeedxWeb.BootstrapIconHelpers do

  @moduledoc """
  Helpers for SVG Icons.
  """

  import Phoenix.HTML

  def check_svg, do: check_svg("")
  def check_svg(:raw), do: check_svg() |> raw()
  def check_svg(klas) do
    """
    <svg class="#{klas}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
      <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
    </svg>
    """
  end
  def check_svg(klas, :raw), do: check_svg(klas) |> raw()

  def check_circle_svg, do: check_circle_svg("")
  def check_circle_svg(:raw), do: check_circle_svg() |> raw()
  def check_circle_svg(klas) do
    """
    <svg class="#{klas}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
      <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
    """
  end
  def check_circle_svg(klas, :raw), do: check_circle_svg(klas) |> raw()

  def plus_circle_svg, do: plus_circle_svg("")
  def plus_circle_svg(:raw), do: plus_circle_svg() |> raw()
  def plus_circle_svg(klas) do
    """
    <svg class="#{klas}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v6m3-3H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
    """
  end
  def plus_circle_svg(klas, :raw), do: plus_circle_svg(klas) |> raw()

  def refresh_svg, do: refresh_svg("")
  def refresh_svg(:raw), do: refresh_svg() |> raw()
  def refresh_svg(klas) do
    """
    <svg class="#{klas}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
      <path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99" />
    </svg>
    """
  end
  def refresh_svg(klas, :raw), do: refresh_svg(klas) |> raw()

  def pencil_alt_svg, do: pencil_alt_svg("")
  def pencil_alt_svg(:raw), do: pencil_alt_svg() |> raw()
  def pencil_alt_svg(klas) do
    """
    <svg class="#{klas}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
      <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125" />
    </svg>
    """
  end
  def pencil_alt_svg(klas, :raw), do: pencil_alt_svg(klas) |> raw()

end
