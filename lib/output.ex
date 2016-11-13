defmodule CognixirDemo.Output do
    require EEx

    @dir "output"

    EEx.function_from_file(:defp, :render_menu, "resources/templates/menu.eex.html", [:img_path, :title, :description, :food_score])

    defp filename(title) do
        String.replace(title, " ", "_")
    end

    defp prepare do
        File.mkdir(@dir)
    end

    def save_menu(image, title, description, food_score) do
        prepare()
        filename = filename(title)
        filepath = Path.join(@dir, filename)

        # save image
        img_file = File.open!("#{filepath}.jpg", [:write])
        IO.binwrite(img_file, image)

        # save html
        menu = render_menu("#{filename}.jpg", title, description, food_score)
        html_file = File.open!("#{filepath}.html", [:write])
        IO.binwrite(html_file, menu)
    end
end
