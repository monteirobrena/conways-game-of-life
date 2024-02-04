require 'rails_helper'

RSpec.describe "Boards", type: :request do
  describe "POST /create" do
    headers = { "ACCEPT" => "application/json" }

    it "returns success when create" do
      post "/boards#create", params: { board: build(:board_hash) }, headers: headers

      response_parsed_body = JSON.parse(response.body)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
      expect(response_parsed_body["id"]).to eq(1)
    end

    it "returns error when unable to create" do
      post "/boards#create", params: { board: build(:board_hash, size: nil) }, headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({ size: ["can't be blank"] }.to_json)
    end

    it "should create with cells" do
      post "/boards#create", params: { board: build(:board_hash, cells: build_list(:cell_hash, 3)) }, headers: headers

      response_parsed_body = JSON.parse(response.body)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
      expect(response_parsed_body["id"]).to eq(1)
      expect(response_parsed_body["cells"].size).to eq(3)
    end
  end
end
