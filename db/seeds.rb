# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Cleaning database..."
Training.destroy_all
Message.destroy_all
Chat.destroy_all
User.destroy_all

puts "Creating users..."
alice = User.create!(
  email: "alice@padel.com",
  password: "password123",
  password_confirmation: "password123",
  age: 28,
  height: 168,
  weight: 62.5,
  padel_level: 3.5,
  hand_position: "Right"
)

bob = User.create!(
  email: "bob@padel.com",
  password: "password123",
  password_confirmation: "password123",
  age: 35,
  height: 182,
  weight: 80.0,
  padel_level: 5.0,
  hand_position: "Left"
)

puts "Creating chat..."
chat = Chat.create!(
  user: alice,
  title: "Analyse de mes séances de padel"
)

puts "Creating messages..."
Message.create!(chat: chat, role: "user",      content: "Peux-tu analyser mes dernières séances d'entraînement ?")
Message.create!(chat: chat, role: "assistant", content: "Bien sûr ! D'après tes séances, tu as progressé en intensité. Continue sur cette lancée et pense à varier les exercices.")

puts "Creating trainings..."
Training.create!(
  user: alice,
  chat: chat,
  training_type: "Lobe",
  duration: 60,
  intensity: 6,
  team_size: 4,
  feedback_rating: 7,
  content: "Séance de jeu libre en double, bon travail au filet."
)

Training.create!(
  user: alice,
  chat: chat,
  training_type: "Classic",
  duration: 90,
  intensity: 8,
  team_size: 2,
  feedback_rating: 9,
  content: "Entraînement technique : smash, volée et service. Très intense."
)

Training.create!(
  user: alice,
  chat: chat,
  training_type: "Classic",
  duration: 45,
  intensity: 7,
  team_size: 1,
  feedback_rating: 8,
  content: "Renforcement musculaire axé sur les jambes et le gainage."
)

Training.create!(
  user: bob,
  chat: chat,
  training_type: "Endurance",
  duration: 75,
  intensity: 9,
  team_size: 4,
  feedback_rating: 8,
  content: "Match de compétition, victoire 6-4 6-3. Excellente communication avec le partenaire."
)

Training.create!(
  user: bob,
  chat: chat,
  training_type: "Classic",
  duration: 30,
  intensity: 5,
  team_size: 1,
  feedback_rating: 6,
  content: "Footing léger pour récupération active après le match."
)

Training.create!(
  user: alice,
  chat: chat,
  training_type: "Endurance",
  duration: 60,
  intensity: 7,
  team_size: 4,
  feedback_rating: 8,
  content: "Jeu en double avec travail sur la coordination et les déplacements."
)

puts "Done! #{User.count} users, #{Chat.count} chat, #{Message.count} messages, #{Training.count} trainings."
