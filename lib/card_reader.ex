defmodule CardReader do
    alias Cognixir.ComputerVision, as: CV

    defp analyze_line(line) do
        line_text = Enum.map(line["words"], fn(word) ->
            word["text"]
        end)

        # look for single tokens
        Enum.each(line_text, fn(text) ->
            if String.contains?(text, "@") do
                IO.puts "Potential email: #{text}"
            end

            if String.match?(text, ~r/^[\.\w\d]+\.[\w]{2,3}$/) do
                IO.puts "Potential website: #{text}"
            end
        end)

        # now check entire line
        if Enum.count(line_text) > 1 do
            joined_text = Enum.join(line_text, " ") |> String.trim
            if String.match?(joined_text, ~r/^[\p{L}\. ]+$/) do
                IO.puts "Potential name or title: #{joined_text}"
            end

            if String.match?(joined_text, ~r/^[\d+() ]+$/) do
                IO.puts "Potential phone number: #{joined_text}"
            end
        end
    end

    defp process_response(response) do
        regions = response["regions"]
        Enum.each(regions, fn(region) ->
            Enum.each(region["lines"], fn(line) ->
                analyze_line(line)
            end)
        end)
    end

    def read_card(image) do
        options = %CV.OCROptions{detectOrientation: true}
        case CV.recognize_character(image, options) do
            { :ok, response } ->
                process_response(response)
            { :error, response } ->
                IO.puts("Error analyzing image :( (#{response})")
        end
    end
end
