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
      content(contents),
      end_tag(tag_name, contents)
    ]
  end

  defp start_tag(tag_name, attributes) do
    [?<, tag_name | attributes(attributes)]
  end

  defp attributes([]), do: []

  defp attributes([{name, value} | attributes]) do
    [0x20, name, ?=, ?", value, ?", attributes(attributes)]
  end

  defp content([]), do: []

  defp content([{:characters, characters} | elements]) do
    [characters(characters) | content(elements)]
  end

  defp content([{:cdata, cdata} | elements]) do
    [cdata(cdata) | content(elements)]
  end

  defp content([element | elements]) do
    [element(element) | content(elements)]
  end

  defp end_tag(tag_name, _other) do
    [?<, ?/, tag_name, ?>]
  end

  defp characters(characters) do
    characters
  end

  defp cdata(characters) do
    ["<![CDATA[", characters | "]]>"]
  end
end
