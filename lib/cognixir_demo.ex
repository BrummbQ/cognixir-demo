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
        Enum.filter(tags, fn(x) -> !String.contains?(x["name"], " ") end)
            |> Enum.take_random(2)
            |> Enum.map_join(" ", &(&1["name"]))
    end

    defp food_score(tags) do
        if Enum.empty?(tags) do
            0
        else
            sum = Enum.reduce(tags, 0, fn(tag, acc) ->
                acc + tag["confidence"]
            end)
            (sum / length(tags)) * 100 |> Float.ceil |> trunc
        end
    end

    defp process_response(result, image) do
        description = result["description"]["captions"] |> hd |> Map.get("text")
        tags = result["tags"]
        food_tags = food_tags(tags)
        generated_name = generate_name(tags)

        CognixirDemo.Output.save_menu(image, generated_name, description, food_score(food_tags))
        IO.puts("Written #{generated_name} to output dir")
    end

    def analyze_image(image) do
        options = %CV.AnalyzeOptions{visualFeatures: "Color,Categories,Tags,Description"}
        case CV.analyze_image(image, options) do
            { :ok, response } ->
                process_response(response, image)
            { :error, response } ->
                IO.puts("Error analyzing image :( (#{response})")
        end
    end
end
