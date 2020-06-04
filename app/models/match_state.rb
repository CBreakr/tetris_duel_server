class MatchState < ApplicationRecord
    belongs_to :match
    belongs_to :game_state
end