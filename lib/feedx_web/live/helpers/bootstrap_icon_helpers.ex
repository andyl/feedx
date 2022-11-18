defmodule FeedxWeb.BootstrapIconHelpers do

  @moduledoc """
  Helpers for SVG Icons.
  """

  import Phoenix.HTML

  def check_svg, do: check_svg("")
  def check_svg(:raw), do: check_svg() |> raw()
  def check_svg(klas) do
    """
    <i class="bi-check #{klas}"></i>
    """
  end
  def check_svg(klas, :raw), do: check_svg(klas) |> raw()

  def check_circle_svg, do: check_circle_svg("")
  def check_circle_svg(:raw), do: check_circle_svg() |> raw()
  def check_circle_svg(klas) do
    """
    <i class="bi-check-circle-fill #{klas}"></i>
    """
  end
  def check_circle_svg(klas, :raw), do: check_circle_svg(klas) |> raw()

  def plus_circle_svg, do: plus_circle_svg("")
  def plus_circle_svg(:raw), do: plus_circle_svg() |> raw()
  def plus_circle_svg(klas) do
    """
    <i class="bi-plus-circle-fill #{klas}"></i>
    """
  end
  def plus_circle_svg(klas, :raw), do: plus_circle_svg(klas) |> raw()

  def refresh_svg, do: refresh_svg("")
  def refresh_svg(:raw), do: refresh_svg() |> raw()
  def refresh_svg(klas) do
    """
    <i class="bi-arrow-repeat #{klas}"></i>
    """
  end
  def refresh_svg(klas, :raw), do: refresh_svg(klas) |> raw()

  def pencil_alt_svg, do: pencil_alt_svg("")
  def pencil_alt_svg(:raw), do: pencil_alt_svg() |> raw()
  def pencil_alt_svg(klas) do
    """
    <i class="bi-pencil #{klas}"></i>
    """
  end
  def pencil_alt_svg(klas, :raw), do: pencil_alt_svg(klas) |> raw()

end
