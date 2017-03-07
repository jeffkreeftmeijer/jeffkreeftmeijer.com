defmodule Mix.Tasks.Blog.Generate do
  def run(root) do
    root
    |> Path.join("index.html")
    |> index(root)
    |> render
    |> generate
  end

  def generate(%{
    output_directory: output_directory,
    output_path: output_path,
    contents: contents,
  }) do
    File.mkdir_p(output_directory)
    File.write!(output_path, contents)
  end

  def render(%{contents: contents, layouts: [layout]} = index) do
    rendered_contents = EEx.eval_string(layout, [assigns: %{inner: contents}])
    Map.put(index, :contents, rendered_contents)
  end

  def index(input_path, root) do
    relative_path = Path.relative_to(input_path, root)
    output_path  = root |> Path.join("_output") |> Path.join(relative_path)

    %{
      output_directory: Path.dirname(output_path),
      output_path: output_path,
      contents: File.read!(input_path),
      layouts: [File.read!(Path.join(root, "_layout.eex"))]
    }
  end
end
