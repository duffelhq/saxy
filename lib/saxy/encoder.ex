defmodule Saxy.Encoder do
  def encode(document) do
    element(document) |> IO.iodata_to_binary()
  end

  defp element({tag_name, attributes, :empty}) do
    [start_tag(tag_name, attributes), ?/, ?>]
  end

  defp element({tag_name, attributes, contents}) do
    [
      start_tag(tag_name, attributes),
      ?>,
      contents(contents),
      end_tag(tag_name, contents)
    ]
  end

  defp start_tag(tag_name, attributes) do
    [?<, tag_name | attributes(attributes)]
  end

  defp attributes([]) do
    []
  end

  defp attributes([{name, value} | attributes]) do
    [0x20, name, ?=, ?", value, ?", attributes(attributes)]
  end

  defp contents([]) do
    []
  end

  defp contents([element | elements]) do
    [element(element) | contents(elements)]
  end

  defp end_tag(tag_name, _other) do
    [?<, ?/, tag_name, ?>]
  end
end
