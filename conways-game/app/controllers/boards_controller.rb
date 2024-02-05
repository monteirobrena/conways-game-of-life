class BoardsController < ApplicationController
  def board_params
    params.require(:board).permit([:size, :attempts, cells: [:alive, :x_position, :y_position]])
  end

  # POST /boards
  def create
    @board = Board.new(board_params.except(:cells)) do |board|
      board.cells.new(board_params[:cells])
    end

    if @board.save
      render json: @board, include: ['cells'], status: :created
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

   # GET /boards/{:id}
  def index
    @board = Board.find(params[:id])
    @board.set_next_state

    render json: @board, include: ['cells'], status: :ok
  end
end
