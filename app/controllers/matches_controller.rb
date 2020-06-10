class MatchesController < ApplicationController

    def active
        # get all of the active matches
        active_matches = Match.active
        puts "ACTIVE MATCHES"
        puts "ACTIVE MATCHES"
        puts "ACTIVE MATCHES"
        puts "ACTIVE MATCHES"
        puts "ACTIVE MATCHES"
        puts active_matches
        render json: active_matches
    end

    def issue_challenge
        puts "ISSUE CHALLENGE"
        puts "ISSUE CHALLENGE"
        puts "ISSUE CHALLENGE"
        puts "ISSUE CHALLENGE"
        # other user id as parameter
        # write out to the ActivePlayerChannel
        ActionCable.server.broadcast "ActivePlayersChannel", {type: "challenge", details: {challenger: current_user.serialized, challenged: params[:id]}}
    end

    def reject_challenge
        # other user id as parameter
        # write out to the ActivePlayerChannel
        challenger = User.find(params[:id])
        challenger.issued_challenge = false
        challenger.save
        ActionCable.server.broadcast "ActivePlayersChannel", {type: "reject", details: {challenger: challenger.id}}
    end

    def cancel_challenge
        cu = current_user
        cu.issued_challenge = false
        cu.save
        ActionCable.server.broadcast "ActivePlayersChannel", {type: "cancel", details: {challenger: cu.id}}
    end

    def accept_challenge
        # other user as parameter
        # write out to the ActivePlayerChannel
        # write out to the ActiveMatchChannel
        # write out to the MatchChannel

        puts "ACCEPT"
        puts "ACCEPT"
        puts "ACCEPT"
        puts "ACCEPT"
        puts "ACCEPT"
        puts params

        cu = current_user
        create(cu, params[:id])
    end

    def create(first_user, second_user_id)
        puts "CREATE MATCH"
        #
        # called by match accepted?
        #
        # match = Match.create(user: current_user)
        # create match
        # create a game for each player
        # write out to ActiveMatchChannel
        # t.integer "game1_id"
        # t.integer "game2_id"
        second_user = User.find(second_user_id)
        game1 = Game.create(user: first_user)
        game2 = Game.create(user: second_user)
        match = Match.new
        match.game_one = game1
        match.game_two = game2
        match.save

        first_user.update(in_lobby: false, issued_challenge: false)
        second_user.update(in_lobby: false, issued_challenge: false)

        ActionCable.server.broadcast "ActivePlayersChannel", {type: "accept", users: [current_user.id, second_user_id], match_id: match.id}
        ActionCable.server.broadcast "ActivePlayersChannel", {type: "remove", users: [current_user.id, second_user_id]}
        ActionCable.server.broadcast "ActiveMatchesChannel", {type: "match_created", match: match.serialized}
    end

    def show

        puts "show"

        match = Match.find(params[:id])

        puts "we have the match"
        puts match

        # client state
        # match_id: null,
        # game1_id: null,
        # game2_id: null,
        # user1: null,
        # user2: null,
        # winner_id: null

        # t.integer "winner_id"
        # t.integer "loser_id"
        # t.integer "game1_id"
        # t.integer "game2_id"

        puts "before render"

        render json: match.serialized
    end

    def update
        # match id, game as parameters
        # write out to the MatchChannel

        game = params[:game]

        gamestate = GameState.new(game_id: game.id)
        gamestate.board_state = game.board_state
        gamestate.next_piece = game.next_piece
        gamestate.move_number = game.move_number + 1
        gamestate.is_finished = game.is_finished
        gamestate.save

        matchstate = MatchState.create(match_id: params[:id], game_state: gamestate)

        match = Math.find(params[:id])

        if game.is_finished then
            match_lost(match, game.id)
        else
            MatchChannel.broadcast_to(match, {type:"match_state", gamestate: game})
        end

    end

    def accept_handshake
        # match id, game id as parameters
        # write out to the MatchChannel if both have been accepted

        match = Match.find(params[:id])
        cu = current_user

        if match.game_one.user.id == cu.id then
            match.user1_handshake = true
        elsif match.game_two.user.id == cu.id then
            match.user2_handshake = true
        end

        match.save

        puts "HANDSHAKE"
        puts "HANDSHAKE"
        puts "HANDSHAKE"
        puts "HANDSHAKE"
        puts match.user1_handshake 
        puts match.user2_handshake

        if match.user1_handshake && match.user2_handshake then
            MatchChannel.broadcast_to(match, {type: "match_start"})
        end
    end

    def concede
        # match id, game_id as parameters
        # write out to the MatchChannel
        # write out to the ActiveMatchChannel

        match = Match.find(params[:id])
        match_lost(match, params[:game_id])
    end

    def match_lost(match, game_id)
        # write out to the MatchChannel

        losing_game = Game.find(game_id)

        # setting the winner automatically sets the loser, too
        if match.game_one.id == game_id then
            match.winner = match.game_two.user
        elsif match.game_two.id == game_id then
            match.winner = match.game_one.user
        end

        MatchChannel.broadcast_to(match, {type:"match_over", winner_id: match.winner_id})
        ActionCable.server.broadcast "ActiveMatchesChannel", {type: "match_ended", match_id: match.id}
    end
end