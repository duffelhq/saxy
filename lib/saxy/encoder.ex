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
    escape(characters, 0, characters)
  end

  defp cdata(characters) do
    ["<![CDATA[", characters | "]]>"]
  end

  @escapes [
    {?<, "&lt;"},
    {?>, "&gt;"},
    {?&, "&amp;"},
    {?", "&quot;"},
    {?', "&apos;"}
  ]

  for {match, insert} <- @escapes do
    defp escape(<<unquote(match), rest::bits>>, len, original) do
      [binary_part(original, 0, len), unquote(insert) | escape(rest, 0, rest)]
    end
  end

  defp escape(<<_, rest::bits>>, len, original) do
    escape(rest, len + 1, original)
  end

  defp escape(<<>>, _len, original) do
    original
  end
end
