class BoardsController < ApplicationController

    # POST /boards
    def create
        render json: { }, status: :created
    end
end
