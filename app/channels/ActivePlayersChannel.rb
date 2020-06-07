class ActivePlayersChannel < ApplicationCable::Channel
    def subscribed
        puts "subscribed to active players"
        stream_from "ActivePlayersChannel"
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end
end