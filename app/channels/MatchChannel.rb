class MatchChannel < ApplicationCable::Channel
    def subscribed
        puts "SUBSCRIBED TO MATCH"
        puts params
        # stream_from "some_channel"
        match = Match.find(params[:id])
        stream_for match
    end

    # question = Question.find(comment.question_id)
    # QuestionChannel.broadcast_to(question, {type: "new", id: comment.id, text: comment.text, user: comment.user, comment_upvotes: comment.comment_upvotes})

    def unsubscribed
        puts "unsubscribed"
        # Any cleanup needed when channel is unsubscribed
    end
end