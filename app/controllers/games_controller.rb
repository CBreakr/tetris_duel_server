class GamesController < ApplicationController

    def create
        puts "CREATE GAME"
        game = Game.create(user: current_user)
        pp game
        render json: {id: game.id}
    end

end