defmodule Mix.Tasks.Blog.Generate do
  def run(path) do
    output_path = path
    |> Path.join("_output")

    index_path = Path.join(path, "index.html")

    File.mkdir_p(output_path)

    contents = path
    |> Path.join("_layout.eex")
    |> EEx.eval_file([assigns: %{inner: File.read!(index_path)}])

    output_path
    |> Path.join("index.html")
    |> File.write!(contents)
  end
end
