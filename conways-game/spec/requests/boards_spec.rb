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

  describe "GET /index" do
    headers = { "ACCEPT" => "application/json" }

    it "returns success when it gets the next state" do
      board = create :board, cells: create_list(:cell, 3)

      get "/boards#index", params: { id: board.id }, headers: headers

      response_parsed_body = JSON.parse(response.body)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response_parsed_body["attempts_performed"]).to eq(1)
      expect(response_parsed_body["cells"].size).to eq(3)
    end

    it "returns success when getting the next state while retries are allowed" do
      board = create(:board, attempts: 2, cells: create_list(:cell, 3))

      get "/boards#index", params: { id: board.id }, headers: headers

      response_parsed_body = JSON.parse(response.body)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response_parsed_body["attempts_performed"]).to eq(1)
      expect(response_parsed_body["cells"].size).to eq(3)

      get "/boards#index", params: { id: board.id }, headers: headers

      response_parsed_body = JSON.parse(response.body)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response_parsed_body["attempts_performed"]).to eq(2)
      expect(response_parsed_body["cells"].size).to eq(3)
    end

    it "returns error when getting the next state after maximum attempts allowed and board did not reach completion" do
      board = create(:board, attempts: 2, cells: create_list(:cell, 3, alive: false))

      get "/boards#index", params: { id: board.id }, headers: headers

      response_parsed_body = JSON.parse(response.body)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response_parsed_body["cells"].size).to eq(3)
      expect(response_parsed_body["attempts_performed"]).to eq(1)

      get "/boards#index", params: { id: board.id }, headers: headers

      response_parsed_body = JSON.parse(response.body)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response_parsed_body["cells"].size).to eq(3)
      expect(response_parsed_body["attempts_performed"]).to eq(2)

      get "/boards#index", params: { id: board.id }, headers: headers

      response_parsed_body = JSON.parse(response.body)

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response_parsed_body).to have_key("message")
      expect(response_parsed_body["message"]).to eq("The board completed")
      expect(response_parsed_body).to_not have_key("cells")
      expect(response_parsed_body).to_not have_key("attempts_performed")
    end
  end
end
