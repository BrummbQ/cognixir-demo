defmodule CognixirDemo do

end

defmodule CognixirDemo.FoodOMat do
    alias Cognixir.ComputerVision, as: CV

    defp food_tags(tags) do
        Enum.filter(tags, fn(tag) ->
            Map.has_key?(tag, "hint") && tag["hint"] == "food"
        end)
    end

    defp generate_name(tags) do
        random_tags = Enum.filter(tags, fn(x) -> !String.contains?(x["name"], " ") end)
            |> Enum.take_random(2)
        Enum.map_join(random_tags, " ", &(&1["name"]))
    end

    defp print_result(result) do
        description = result["description"]["captions"] |> hd |> Map.get("text")
        tags = result["tags"]
        food_tags = food_tags(tags)
        generated_name = generate_name(tags)

        if Enum.empty?(food_tags) do
            IO.puts "Don't eat that!"
            IO.puts "I can see: \"#{description}\""
            IO.puts "Menu name: \"#{generated_name}\" (if you want to eat it anyway)"
        else
            IO.puts "Yummy!"
            IO.puts "You might enjoy: #{description}"
            Enum.each(food_tags, fn(tag) ->
                name = tag["name"]
                confidence = tag["confidence"] * 100 |> Float.ceil |> trunc
                IO.puts "#{name} (food score: #{confidence})"
            end)
            IO.puts "Menu name: \"#{generated_name}\""
        end
    end

    def analyze_image(image) do
        options = %CV.AnalyzeOptions{visualFeatures: "Color,Categories,Tags,Description"}
        case CV.analyze_image(image, options) do
            { :ok, response } ->
                print_result(response)
            { :error, response } ->
                IO.puts("unknown error :( (#{response})")
        end
    end
end
