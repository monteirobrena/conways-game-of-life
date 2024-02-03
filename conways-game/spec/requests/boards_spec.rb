require 'rails_helper'

RSpec.describe "Boards", type: :request do
  describe "POST /create" do
    headers = { "ACCEPT" => "application/json" }

    it "returns success when create" do
      post "/boards#create", params: { board: { size: 30, attempts: 10 } }, headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
      expect(response.body).to eq({ id: 1 }.to_json)
    end

    it "returns error when unable to create" do
      post "/boards#create", params: { board: { attempts: 10 } }, headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ size: ["can't be blank"] }.to_json)
    end
  end
end
