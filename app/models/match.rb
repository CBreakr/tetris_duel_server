class Match < ApplicationRecord
    # this is where I have to figure out how to wire things up
    belongs_to :game_one, foreign_key: 'game1_id', class_name: 'Game'
    belongs_to :game_two, foreign_key: 'game2_id', class_name: 'Game'

    def winner
        User.find(self.winner_id)
    end

    def loser 
        User.find(self.loser_id)
    end

    def winner= (user)
        self.winner_id = user.id
        users = self.users
        if users[0].id == user.id then
            self.loser_id = users[1].id
        else
            self.loser_id = users[0].id
        end

        self.winner.update_rank(true, self.loser.rank)
        self.loser.update_rank(false, self.winner.rank)

        self.save
    end

    def users
        return [game_one.user, game_two.user]
    end

    def self.active 
        Match.where(winner_id: nil).map do |match|
            match.serialized
        end
    end

    def serialized
        {   match_id: self.id,
            game1_id: self.game1_id, 
            game2_id: self.game2_id, 
            user1: self.game_one.user.serialized,
            user2: self.game_two.user.serialized,
            winner_id: self.winner_id
        }
    end
end