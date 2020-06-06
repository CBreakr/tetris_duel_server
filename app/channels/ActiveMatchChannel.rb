class ActiveMatchChannel < ApplicationCable::Channel
    def subscribed
        puts "subscribed to active matches"
        stream_from "ActiveMatchChannel"
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end
end