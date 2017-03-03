defmodule Mix.Tasks.Blog.Generate do
  def run(path) do
    output_path = path
    |> Path.join("_output")

    File.mkdir_p(output_path)

    path
    |> Path.join("index.html")
    |> File.cp(Path.join(output_path, "index.html"))
  end
end
