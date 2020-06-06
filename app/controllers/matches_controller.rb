class GamesController < ApplicationController

    def active

    end

    def create
        puts "CREATE MATCH"
        # match = Match.create(user: current_user)
        render json: {id: match.id}
    end

    def issue_challenge
        # other user id as parameter
        # write out to the ActivePlayerChannel
    end

    def reject_challenge
        # other user id as parameter
        # write out to the ActivePlayerChannel
    end

    def accept_challenge
        # other user as parameter
        # write out to the ActivePlayerChannel
        # write out to the ActiveMatchChannel
        # write out to the MatchChannel
    end

    def update
        # match id, game id, game state as parameters
        # write out to the MatchChannel
    end

    def accept_handshake
        # match id, game id as parameters
        # write out to the MatchChannel
    end

    def concede
        # match id as parameter
        # write out to the MatchChannel
        # write out to the ActiveMatchChannel
    end

    def match_lost
        # match id as parameter
        # write out to the MatchChannel
        # write out to the ActiveMatchChannel
    end

end