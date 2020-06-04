class Game < ApplicationRecord
    belongs_to :user

    has_one :match_as_game_one, foreign_key: 'game1_id', class_name: 'Match'
    has_one :match_as_game_two, foreign_key: 'game2_id', class_name: 'Match'

    has_many :game_states

    def match
        match_g1 = self.match_as_game_one
        match_g2 = self.match_as_game_two
        
        if match_g1 then
            match_g1
        elsif match_g2 then
            match_g2
        end

        nil
    end
end