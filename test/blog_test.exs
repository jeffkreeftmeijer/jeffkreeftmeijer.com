defmodule BlogTest do
  use ExUnit.Case

  setup do
    clean_output()

    on_exit &clean_output/0
  end

  test "copies index.html to the _output directory" do
    Mix.Tasks.Blog.Generate.run("test/site/")
    assert File.read!("test/site/_output/index.html") == File.read!("test/site/index.html")
  end

  defp clean_output do
    File.rm_rf("test/site/_output")
  end
end
