defmodule CardReaderTest do
  use ExUnit.Case
  doctest CognixirDemo

  test "read all card" do
      Enum.each(1..3, fn(num) ->
          IO.puts("Reading card #{num}")
          file_content = File.read!("resources/img/card#{num}.jpg")
          CardReader.read_card(file_content)
      end)
  end
end
