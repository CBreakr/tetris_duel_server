class GamesController < ApplicationController

    def create
        game = Game.create(user: current_user)
        render json: {id: game.id}
    end

    def update
        # t.string "board_state"
        # t.string "next_piece"
        # t.integer "move_number"
        # t.boolean "is_finished"
        game = Game.find(params[:id])
        game.board_state = params[:board_state]
        game.next_piece = params[:next_piece]
        game.move_number += 1
        game.is_finished = params[:is_finished]
        render json: {message: success}
    end

end