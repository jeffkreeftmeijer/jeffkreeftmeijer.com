defmodule BlogTest do
  use ExUnit.Case

  setup do
    clean_output()
    Mix.Tasks.Blog.Generate.run("test/site/")

    on_exit &clean_output/0
  end

  test "uses _layout.eex to generate _output/index.html" do
    assert "layout.eex(index.html)" == File.read!("test/site/_output/index.html")
  end

  test "uses _layout.eex to generate _output/article/index.html" do
    assert "layout.eex(article/index.html)" == File.read!("test/site/_output/article/index.html")
  end

  test "renders and layouts a markdown file" do
    assert "layout.eex(<p>markdown.md</p>\n)" == File.read!("test/site/_output/markdown.html")
  end

  test "does not render non-HTML or -Markdown files" do
    refute File.exists?("test/site/_output/file.txt")
  end

  defp clean_output do
    File.rm_rf("test/site/_output")
  end
end
