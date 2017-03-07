defmodule BlogTest do
  use ExUnit.Case

  setup do
    clean_output()

    on_exit &clean_output/0
  end

  test "uses _layout.eex to generate _output/index.html" do
    Mix.Tasks.Blog.Generate.run("test/site/")
    assert "layout.eex(index.html)" == File.read!("test/site/_output/index.html")
  end

  test "uses _layout.eex to generate _output/article/index.html" do
    Mix.Tasks.Blog.Generate.run("test/site/")
    assert "layout.eex(article/index.html)" == File.read!("test/site/_output/article/index.html")
  end

  defp clean_output do
    File.rm_rf("test/site/_output")
  end
end
