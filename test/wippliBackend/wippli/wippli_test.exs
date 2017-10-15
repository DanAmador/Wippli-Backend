defmodule WippliBackend.WippliTest do
  use WippliBackendWeb.ConnCase

  alias WippliBackend.Wippli.RequestHelper
  alias WippliBackend.Accounts

  describe "Accounts" do
    test "get or create user by telegram id " do
      #Create user
      {:ok, user} =  Accounts.get_or_create_user_by_telegram_id("1")
      assert user.telegram_id == "1"
      #Again to retrieve same user
      user2 =  Accounts.get_or_create_user_by_telegram_id("1")
      assert user == user2
    end
  end

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
