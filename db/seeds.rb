# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Game.destroy_all
GameState.destroy_all
Match.destroy_all
MatchState.destroy_all

puts "RUNNING"

user1 = User.create!(name:"RobNot", rank: -1, password:"222")
user2 = User.create!(name:"VMac", rank: -1, password:"222")

pp user2

game1 = Game.create!(user: user1)
game2 = Game.create!(user: user2)

pp user2

match1 = Match.create!(game_one: game1, game_two: game2)

pp user2
puts user2.id
puts "BEFORE SET WINNER"

# somehow this is changing the id?
match1.winner = user2

puts "USER ID"
puts user2.id
puts "WINNER ID"
puts match1.winner_id

puts "AFTER SET WINNER"
pp user2

puts "WINNER"
pp match1.winner

puts "MATCHES"
pp user2.matches_won
