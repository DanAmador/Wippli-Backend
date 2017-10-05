defmodule WippliBackend.WippliTest do
  use WippliBackend.DataCase

  alias WippliBackend.Wippli.RequestHelper

  describe "requests" do
    @symph_response %{
      source_id: "LNlrXGgwBgo",
      thumbnail: "https://i.ytimg.com/vi/LNlrXGgwBgo/default.jpg",
      title: "Bach Sinfonia No.2 - P. Barton, FEURICH Harmonic Pedal piano",
      url: "http://youtu.be/LNlrXGgwBgo"
    }

   test "parse_url/1 with vanilla youtube link " do
      resp = RequestHelper.parse_url("https://www.youtube.com/watch?v=LNlrXGgwBgo")
      assert resp == @symph_response
    end

   test "parse_url/1 with shortened youtube link " do
     resp = RequestHelper.parse_url("https://youtu.be/LNlrXGgwBgo")
     assert resp == @symph_response
   end

   test "parse_url/1 with shortened youtube link with timestamp " do
     resp = RequestHelper.parse_url("https://youtu.be/LNlrXGgwBgo&t=6s")
     assert resp == @symph_response
   end


  end
end
