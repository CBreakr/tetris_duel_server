class UsersController < ApplicationController

    skip_before_action :authorized, except: :ping

    def ping
        render json: {success: true}
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
        user.rank = -1
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
        current_user.end_session
    end

    def all
        users = User.all
        games = Game.all
        game_states = GameState.all
        matches = Match.all
        match_states = MatchState.all

        ActionCable.server.broadcast 'DefaultChannel', {message:"this is a message from the default channel"}

        puts "We have the data"
        pp users
        pp games
        pp matches

        render json: { users: users, games:games, game_states:game_states, matches:matches, match_states:match_states }
    end

    def available
        # return all of the available users
        User.all.select do |user|
            user.in_lobby && !user.issued_challenge
        end
    end

    def enter_lobby
        cu = current_user
        set_user_to_lobby(cu)
    end

    def set_user_to_lobby(user)
        user.in_lobby = true
        user.save
        # write to the ActivePlayerChannel
        ActionCable.server.broadcast "ActivePlayerChannel", {type: "enter_lobby", message: cu}
    end

    private
    def user_params 
        puts params
        params.require(:user).permit(:name, :password)
    end
end
