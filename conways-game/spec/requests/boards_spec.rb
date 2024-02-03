require 'rails_helper'

RSpec.describe "Boards", type: :request do
  describe "POST /create" do
    it "returns http created" do
      headers = { "ACCEPT" => "application/json" }
      post "/boards#create", params: { board: { size: 30, attempts: 10 } }, headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
    end
  end
end
