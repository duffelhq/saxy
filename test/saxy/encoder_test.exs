defmodule Saxy.EncoderTest do
  use ExUnit.Case

  test "encodes empty element" do
    document = {"person", [{"first_name", "John"}, {"last_name", "Doe"}], :empty}
    xml = Saxy.Encoder.encode(document)

    assert xml == "<person first_name=\"John\" last_name=\"Doe\"/>"
  end

  test "encodes normal element" do
    document = {"person", [{"first_name", "John"}, {"last_name", "Doe"}], []}
    xml = Saxy.Encoder.encode(document)

    assert xml == "<person first_name=\"John\" last_name=\"Doe\"></person>"
  end

  test "encodes nested element" do
    children = [
      {"address", [{"street", "foo"}, {"city", "bar"}], :empty},
      {"gender", [{"male", "true"}], []}
    ]
    document = {"person", [{"first_name", "John"}, {"last_name", "Doe"}], children}
    xml = Saxy.Encoder.encode(document)

    assert xml == "<person first_name=\"John\" last_name=\"Doe\"><address street=\"foo\" city=\"bar\"/><gender male=\"true\"></gender></person>"
  end
end
