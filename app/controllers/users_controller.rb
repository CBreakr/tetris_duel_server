class UsersController < ApplicationController

    skip_before_action :authorized, except: [:ping, :logout]

    def ping
        render json: {success: true}
    end

    def show
        puts "SHOW USER"
        puts "SHOW USER"
        puts "SHOW USER"
        puts "SHOW USER"
        puts params[:id]
        user = User.find(params[:id])
        puts user
        render json: user.serialized
    end

    def login
        user = User.find_by(name: user_params[:name])
        #User#authenticate comes from BCrypt

        puts "FOUND USER?"
        puts user

        up = user_params
        puts up[:password_digest]

        if user && user.authenticate(up[:password])
            user.start_session
            set_user_to_lobby(user)
            # encode token comes from ApplicationController
            puts "AUTHENTICATED"
            token = encode_token({ user_id: user.id })
            render json: { id: user.id, name: user.name, jwt: token }, status: :accepted
        else
            puts "NOT AUTHENTICATED"
            render json: { message: 'Invalid username or password' }, status: :unauthorized
        end
    end

    def register
        up = user_params
        puts up
        user = User.new(up)
        puts "CREATED USER"
        puts user
        if user.save
            user.start_session
            set_user_to_lobby(user)
            token = encode_token(user_id: user.id)
            render json: { id: user.id, name: user.name, jwt: token }, status: :created
        else
            puts user.errors.full_messages
            render json: { error: 'failed to create user' }, status: :not_acceptable
        end
    end

    def logout
        cu = current_user
        ActionCable.server.broadcast "ActivePlayersChannel", {type: "remove", users: [cu.id]}
        end_active_match(cu)
        cu.end_session        
    end

    def end_active_match(user)
        # if the user is in a match, they lose
        # mark the match as over, send the proper channel messages
        active = Match.where(winner_id: nil)

        current_match = nil
        current_game = nil

        current = active.each do |match|
            if match.game_one.user.id == user.id then
                current_match = match
                current_game = match.game_one
            elsif match.game_two.user.id == user.id then
                current_match = match
                current_game = match.game_two
            end
        end

        if current_match then
            current_match.process_match_lost(current_game.id)
        end
    end

    def all
        # users = User.all
        # games = Game.all
        # game_states = GameState.all
        # matches = Match.all
        # match_states = MatchState.all

        # ActionCable.server.broadcast 'DefaultChannel', {message:"this is a message from the default channel"}

        # ActionCable.server.broadcast "ActivePlayersChannel", {type: "challenge", details: {challenger: "ER", challenged: "ED"}}
        # ActionCable.server.broadcast "ActiveMatchesChannel", {type: "match_created", match: "a match is here!"}

        # firstMatch = Match.first
        # MatchChannel.broadcast_to(firstMatch, {type:"match_state", gamestate: ""})

        # render json: { users: users, games:games, game_states:game_states, matches:matches, match_states:match_states }
    end

    def available
        # return all of the available users
        puts "AVAILABLE"
        puts "AVAILABLE"
        puts "AVAILABLE"
        puts "AVAILABLE"
        users_available = User.all.select do |user|
            pp user
            puts user.in_lobby && !user.issued_challenge
            user.in_lobby && !user.issued_challenge && user.last_activity > (DateTime.now - User.ACTIVE_TIMEOUT_MINUTES.minutes)
        end.map do |user|
            user.serialized
        end

        render json: users_available
    end

    def enter_lobby
        cu = current_user
        set_user_to_lobby(cu)
    end

    def set_user_to_lobby(user)
        user.in_lobby = true
        user.last_activity = DateTime.now
        user.save
        pp user
        # write to the ActivePlayerChannel
        ActionCable.server.broadcast "ActivePlayersChannel", {type: "enter_lobby", player: user.serialized}
    end

    private
    def user_params 
        puts params
        params.require(:user).permit(:name, :password)
    end
end
