defmodule Saxy.EncoderTest do
  use ExUnit.Case

  test "encodes empty element" do
    document = {"person", [{"first_name", "John"}, {"last_name", "Doe"}], :empty}
    xml = Saxy.Encoder.encode(document)

    assert xml == "<person first_name=\"John\" last_name=\"Doe\"/>"
  end

  test "encodes normal element" do
    content = [
      {:characters, "Hello my name is John Doe"}
    ]
    document = {"person", [{"first_name", "John"}, {"last_name", "Doe"}], content}
    xml = Saxy.Encoder.encode(document)

    assert xml == "<person first_name=\"John\" last_name=\"Doe\">Hello my name is John Doe</person>"
  end

  test "encodes nested element" do
    children = [
      {"address", [{"street", "foo"}, {"city", "bar"}], :empty},
      {"gender", [], [{:characters, "male"}]}
    ]
    document = {"person", [{"first_name", "John"}, {"last_name", "Doe"}], children}
    xml = Saxy.Encoder.encode(document)

    assert xml == "<person first_name=\"John\" last_name=\"Doe\"><address street=\"foo\" city=\"bar\"/><gender>male</gender></person>"
  end
end
