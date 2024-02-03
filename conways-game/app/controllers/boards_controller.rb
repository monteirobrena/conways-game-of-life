class BoardsController < ApplicationController
  def board_params
    params.require(:board).permit([:size, :attempts])
  end

  # POST /boards
  def create
    @board = Board.new(board_params)

    if @board.save
      render json: { id: @board.id }, status: :created
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end
end
