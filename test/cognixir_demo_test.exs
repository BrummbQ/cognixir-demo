defmodule CognixirDemoTest do
  use ExUnit.Case
  doctest CognixirDemo

  test "positive food test" do
      file_content = File.read!("resources/banana.jpg")
      CognixirDemo.FoodOMat.analyze_image(file_content)
  end

  test "negative food test" do
      file_content = File.read!("resources/stone.jpg")
      CognixirDemo.FoodOMat.analyze_image(file_content)
  end
end
