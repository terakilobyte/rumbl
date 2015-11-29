defmodule Rumbl.PageControllerTest do
  use Rumbl.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to Rumbl.io!"
  end
end
