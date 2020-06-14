class User < ApplicationRecord
    has_many :games

    # has_many :matches_won_relationships, foreign_key: :winner_id, class_name: 'Match'
    # has_many :matches_won, through: :matches_won_relationships, source: :winner

    validates :name, uniqueness: { case_sensitive: false }

    has_secure_password

    RANK_SHIFT_CONSTANT = 20
    RANK_EXP_DIVISOR = 100
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
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts "UPDATE RANK"
        puts won
        puts opponent_rank

        diff = (self.rank - opponent_rank).abs

        exp = (self.rank - opponent_rank)/RANK_EXP_DIVISOR
        prob = 1 - 1/(1+ 10**exp)
        result = won ? 1 : 0

        puts exp
        puts prob
        puts result

        # I want to take the value here and extend it base on the the gap
        # so the larger the gap, the bigger the potential shift
        factor = Math.log(diff + 30, 10)/Math.log(30,10)

        self.rank += RANK_SHIFT_CONSTANT * (result - prob) * factor
        if self.rank < MINIMUM_RANK then
            self.rank = MINIMUM_RANK
        end

        puts self.rank
        puts "END UPDATE"
        puts "END UPDATE"

        self.save
    end

    def display_rank
        ((self.rank - MINIMUM_RANK)/4).floor + 10
        # self.rank
    end

    def start_session
        self.logged_in = true
        self.last_activity = Time.now
    end

    def end_session
        self.logged_in = false
        self.issued_challenge = false
        self.in_lobby = false
        self.save
    end

    def serialized
        {id: self.id, name: self.name, rank: self.display_rank, issued_challenge: self.issued_challenge}
    end
end