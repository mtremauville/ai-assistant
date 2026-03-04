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
  name: "Le Chasseur de Vitres",
  training_type: "Défense",
  duration: 30,
  intensity: 6,
  team_size: 2,
  feedback_rating: 8,
  image_url: "https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=800&q=80",
  content: "1. Positionnement : Le partenaire se place au filet pour smasher (sans chercher le coup gagnant direct). Tu te tiens à 1,5 mètre de la vitre de fond.\n\n2. L'engagement : Le partenaire envoie un smash lifté vers le centre du terrain.\n\n3. L'action : Tu dois accompagner la balle vers la vitre de fond sans la toucher avant le rebond. Une fois que la balle ressort de la vitre, effectue ton lob.",
  maestro_conseil: "L'erreur classique est de rester trop droit. Fléchissez les genoux pour que votre centre de gravité soit bas — cela vous permettra d'anticiper la trajectoire de la balle sur la vitre et d'exécuter un lob fluide et précis."
)

Training.create!(
  user: alice,
  chat: chat,
  name: "Le Mur Infranchissable",
  training_type: "Volée",
  duration: 45,
  intensity: 7,
  team_size: 1,
  feedback_rating: 9,
  image_url: nil,
  content: "1. Position de départ : Placez-vous au filet, en position de volée haute, raquette devant vous.\n\n2. L'exercice : Le partenaire envoie des balles variées depuis le fond du court. Votre objectif est de placer chaque volée dans les coins, en variant les angles.\n\n3. Objectif : Empêcher l'adversaire de lober en anticipant sa trajectoire et en fermant les angles.",
  maestro_conseil: "Ne cherchez pas la puissance — cherchez le placement. Une volée bien placée à 1 mètre du filet dans le couloir vaut mieux qu'un smash raté. Gardez les poignets fermes et utilisez le rebond de la raquette."
)

Training.create!(
  user: alice,
  chat: chat,
  name: "La Bandeja Chirurgicale",
  training_type: "Smash",
  duration: 95,
  intensity: 8,
  team_size: 4,
  feedback_rating: 8,
  image_url: nil,
  content: "1. Mise en place : Deux joueurs au fond, deux au filet. Les joueurs du fond s'entraînent à la bandeja en alternance.\n\n2. L'exercice : Lorsqu'une balle haute arrive, effectuez une bandeja en visant la bande latérale, avec une trajectoire plongeante et précise.\n\n3. Rotation : Après chaque bandeja, le joueur retourne en position de défense. Rotation toutes les 10 frappes.",
  maestro_conseil: "La bandeja n'est pas un smash — c'est un coup de contrôle. Visez à frapper la balle légèrement en avant de votre corps, avec un mouvement de haut en bas. L'objectif est de forcer l'adversaire à la faute par la trajectoire, pas par la puissance."
)

Training.create!(
  user: bob,
  chat: chat,
  name: "Le Maître du Slice",
  training_type: "Technique",
  duration: 60,
  intensity: 5,
  team_size: 2,
  feedback_rating: 7,
  image_url: nil,
  content: "1. Échauffement : 5 minutes d'échanges en slice depuis le fond du court.\n\n2. L'exercice : En situation de jeu, chaque coup de fond doit être joué en slice, en visant les pieds de l'adversaire au filet.\n\n3. Variante avancée : Alterner slice court (qui tombe proche du filet) et slice long (qui glisse vers la vitre de fond).",
  maestro_conseil: "Le slice est une arme défensive et offensive à la fois. Travaillez à ouvrir la face de raquette juste avant l'impact pour donner un effet coupé maximal. Un bon slice bas oblige l'adversaire à jouer une volée basse difficile à conclure."
)

puts "Done! #{User.count} users, #{Chat.count} chat, #{Message.count} messages, #{Training.count} trainings."
