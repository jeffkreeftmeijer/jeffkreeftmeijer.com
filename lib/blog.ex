defmodule Mix.Tasks.Blog.Generate do
  def run(root) do
    root
    |> Path.join("**/*.{html,md}")
    |> Path.wildcard
    |> index(root)
    |> render
    |> generate
  end

  def generate([]), do: :ok
  def generate([%{
    output_directory: output_directory,
    output_path: output_path,
    contents: contents,
  }|tail]) do
    File.mkdir_p(output_directory)
    File.write!(output_path, contents)
    generate(tail)
  end

  def render([]), do: []
  def render([%{contents: contents, extension: ".md"} = index|tail]) do
    rendered_contents = Earmark.as_html!(contents, %Earmark.Options{footnotes: true})
    new_index = index
    |> Map.put(:extension, ".html")
    |> Map.put(:contents, rendered_contents)

    render([new_index|tail])
  end
  def render([%{contents: contents, layouts: [layout], relative_path: path} = index|tail]) do
    rendered_contents = EEx.eval_string(layout, [assigns: %{inner: contents, path: path}])
    [Map.put(index, :contents, rendered_contents)|render(tail)]
  end

  def index([], _root), do: []
  def index([input_path|tail], root) do
    relative_path = Path.relative_to(input_path, root)
    output_path  = root
    |> Path.join("_output")
    |> Path.join(relative_path)
    |> String.replace_trailing(".md", ".html")

    case File.dir?(input_path) do
      true -> index(tail, root)
      false ->
        [%{
          extension: Path.extname(input_path),
          output_directory: Path.dirname(output_path),
          output_path: output_path,
          contents: File.read!(input_path),
          relative_path: relative_path,
          layouts: [File.read!(Path.join(root, "_layout.eex"))]
        }|index(tail, root)]
    end
  end
end
