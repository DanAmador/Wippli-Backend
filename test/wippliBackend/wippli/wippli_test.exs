defmodule WippliBackend.WippliTest do
  use WippliBackend.DataCase

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Song
  describe "requests" do

    test "parse_url/1 to return song struct " do
      resp = Wippli.parse_url("https://www.youtube.com/watch?v=Bn9sDYfRE0Q")
      assert resp != %{}
    end
  end
end
