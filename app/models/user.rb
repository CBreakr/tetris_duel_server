class User < ApplicationRecord
    has_many :games

    # has_many :matches_won_relationships, foreign_key: :winner_id, class_name: 'Match'
    # has_many :matches_won, through: :matches_won_relationships, source: :winner

    validates :name, uniqueness: { case_sensitive: false }

    has_secure_password

    RANK_SHIFT_CONSTANT = 30
    RANK_EXP_DIVISOR = 50
    MINIMUM_RANK = 200.0

    def matches_completed
        [self.matches_won, self.matches_lost].flatten
    end

    def matches_lost
        Match.where(loser_id: self.id)
    end
    
    def matches_won
        Match.where(winner_id: self.id)
    end

    def update_rank(won, opponent_rank)
        exp = (self.rank - opponent_rank)/RANK_EXP_DIVISOR
        prob = 1/(1+ 10**exp)
        result = won ? 1 : 0
        self.rank += RANK_SHIFT_CONSTANT * (result - prob)
        if self.rank < MINIMUM_RANK then
            self.rank = MINIMUM_RANK
        end
        self.save
    end

    def display_rank
        ((self.rank - MINIMUM_RANK)/5).floor
    end

    def start_session
        self.logged_in = true
        self.last_activity = Time.now
    end

    def end_session
        self.logged_in = false
        self.save
    end
end