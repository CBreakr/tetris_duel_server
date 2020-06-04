class User < ApplicationRecord
    has_many :games

    # has_many :matches_won_relationships, foreign_key: :winner_id, class_name: 'Match'
    # has_many :matches_won, through: :matches_won_relationships, source: :winner

    validates :name, uniqueness: { case_sensitive: false }

    has_secure_password

    def matches_completed
        [self.matches_won, self.matches_lost].flatten
    end

    def matches_lost
        Match.where(loser_id: self.id)
    end
    
    def matches_won
        Match.where(winner_id: self.id)
    end
end