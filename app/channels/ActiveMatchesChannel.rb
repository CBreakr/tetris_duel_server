class ActiveMatchesChannel < ApplicationCable::Channel
    def subscribed
        puts "subscribed to active matches"
        stream_from "ActiveMatchesChannel"
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end
end