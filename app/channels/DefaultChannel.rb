class DefaultChannel < ApplicationCable::Channel
    def subscribed
        puts "subscribed to notification"
        stream_from "DefaultChannel"
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end
end