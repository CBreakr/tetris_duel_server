class ActivePlayerChannel < ApplicationCable::Channel
    def subscribed
        puts "subscribed to active players"
        stream_from "ActivePlayerChannel"
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end
end