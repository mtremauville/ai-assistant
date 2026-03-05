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

habib = User.create!(
  email: "habib@padel.com",
  password: "croissant",
  password_confirmation: "croissant",
  age: 23,
  height: 190,
  weight: 60.0,
  padel_level: 4.5,
  hand_position: "Left"
)

puts "Creating chat..."
chat = Chat.create!(
  user: alice,
  title: "Analyse de mes séances de padel"
)

puts "Creating messages..."
Message.create!(chat: chat, role: "user",      content: "Test message user")
Message.create!(chat: chat, role: "assistant", content: "Test response assistant")

puts "Creating trainings..."
Training.create!(
  user: alice,
  chat: chat,
  name: "Le Chasseur de Vitres",
  training_type: "Défense",
  duration: 55,
  intensity: 6,
  team_size: 2,
  feedback_rating: 8,
  image_url: "https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=800&q=80",
  maestro_conseil: "L'erreur classique est de rester trop droit. Fléchissez les genoux pour que votre centre de gravité soit bas — cela vous permettra d'anticiper la trajectoire de la balle sur la vitre et d'exécuter un lob fluide et précis.",
  content: <<~MD
    ## Objectif
    Maîtriser la défense sur la vitre de fond et développer l'automatisme du lob défensif. Cette séance vous apprend à lire la trajectoire de la balle après le rebond sur la vitre et à transformer une situation défensive en contre-attaque efficace.

    ## Matériel
    - 20 balles minimum
    - Cônes de délimitation (facultatif)

    ## Échauffement — 10 min
    1. Footing léger autour du court (2 min)
    2. Montées de genoux et talons-fesses sur la ligne de fond (2 min)
    3. Échanges croisés à mi-court, balle liftée uniquement (3 min)
    4. Étirements dynamiques des épaules et des poignets (3 min)

    ## Programme

    ### Exercice 1 — Prise de marque sur la vitre — 10 min
    1. Le joueur A se place au filet et envoie un smash lifté modéré vers le centre du terrain.
    2. Le joueur B se positionne à 1,5 m de la vitre de fond, dos légèrement orienté.
    3. B laisse la balle rebondir sur la vitre, accompagne sa trajectoire **sans la toucher avant le rebond**.
    4. Dès que la balle ressort, B exécute un lob haut et profond vers le fond adverse.
    - **Points clés :** genoux fléchis en permanence, regard sur la balle jusqu'à l'impact, épaule gauche en avant pour orienter le lob.

    ### Exercice 2 — Vitre latérale + lob croisé — 12 min
    1. A envoie une balle vers la vitre latérale gauche de B.
    2. B se déplace latéralement, colle la vitre, attend le rebond et lobe en croisé.
    3. A retourne au centre et prépare la volée de réponse (sans smash).
    4. Répétez 10 fois par côté, puis inversez les rôles.
    - **Points clés :** ne jamais tourner le dos à la vitre, pieds actifs en déplacement, lob avec effet lifté pour gagner de la profondeur.

    ### Exercice 3 — Défense sous pression — 10 min
    1. A enchaîne deux smashes successifs (fond puis latéral).
    2. B doit défendre les deux balles en restant dans la zone de fond.
    3. Après la deuxième défense, B tente de prendre le filet si le lob est suffisamment profond.
    4. Rotation toutes les 8 séquences.
    - **Points clés :** anticiper dès que A frappe, ne pas se précipiter vers la balle, rester équilibré après chaque lob.

    ### Exercice 4 — Situation de match — 8 min
    1. Jeu en point joué : A smash, B défend. Si B lobe profond, il gagne le point dès qu'A commet une faute.
    2. Si A smash une troisième fois gagnant, c'est un point pour A.
    3. Premier à 10 points gagne la série.

    ## Variantes
    - **Faciliter :** A envoie la balle à la main (sans raquette) pour ralentir le rythme.
    - **Progresser :** A vise les coins de vitre (angle vitre-mur latéral) pour complexifier la trajectoire.
    - **Avancé :** B doit lobber et enchaîner immédiatement une prise de filet si A recule.

    ## Récupération — 5 min
    1. Marche lente sur l'ensemble du court (2 min)
    2. Étirement quadriceps et ischio-jambiers debout (1 min par jambe)
    3. Étirement de l'épaule dominant (1 min chaque côté)
  MD
)

Training.create!(
  user: alice,
  chat: chat,
  name: "Le Mur Infranchissable",
  training_type: "Volée",
  duration: 60,
  intensity: 7,
  team_size: 2,
  feedback_rating: 9,
  image_url: "https://padelmagazine.fr/wp-content/uploads/2022/12/Fiona-Ligi-bandeja-France-septembre-2022.jpg.webp",
  maestro_conseil: "Ne cherchez pas la puissance — cherchez le placement. Une volée bien placée dans le couloir à 1 m du filet vaut mieux qu'un smash raté. Gardez les poignets fermes et laissez la raquette bloquer la balle.",
  content: <<~MD
    ## Objectif
    Développer la solidité et la précision au filet en travaillant le contrôle des angles de volée. L'objectif est de neutraliser les attaques adverses et de forcer la faute par le placement, pas par la puissance brute.

    ## Matériel
    - 25 balles
    - Cibles (cônes ou cerceaux) placées dans les couloirs et les coins

    ## Échauffement — 10 min
    1. Échanges doux depuis la position filet/fond (3 min)
    2. Volées basses alternées : A et B se font face à 3 m l'un de l'autre (3 min)
    3. Déplacements latéraux avec toucher de filet à chaque extrémité (2 min)
    4. Rotations des poignets et étirements des avant-bras (2 min)

    ## Programme

    ### Exercice 1 — Volée de placement — 10 min
    1. B se positionne au filet (ligne de service), raquette haute, en garde.
    2. A alimente depuis le fond avec des balles variées (gauche, droite, centrées).
    3. B doit placer chaque volée dans l'un des coins définis par les cônes.
    4. Compter le nombre de cibles touchées sur 20 balles.
    - **Points clés :** raquette toujours au-dessus du poignet, pas de swing — bloquer la balle, se déplacer vers la balle avant de frapper.

    ### Exercice 2 — Volée croisée vs long de ligne — 12 min
    1. A envoie des balles alternées : une croisée, une long de ligne.
    2. B doit renvoyer la croisée en long de ligne et la long de ligne en croisée (inversion systématique).
    3. 3 séries de 15 balles, pause 30 secondes entre chaque série.
    - **Points clés :** anticipation dès que A prend le backswing, poids du corps vers l'avant à l'impact, angle d'ouverture de raquette contrôlé.

    ### Exercice 3 — Volée sous pression rythmique — 10 min
    1. A envoie 3 balles consécutives sans pause (rythme accéléré).
    2. B doit volleyer les 3 en restant en position haute.
    3. À la 4ème balle, B est autorisé à smasher si la balle est haute.
    4. Rotation après 5 séquences.
    - **Points clés :** ne reculer à aucun moment, épaules parallèles au filet, regarder la balle jusqu'à la frappe.

    ### Exercice 4 — Jeu en situation 1 contre 1 — 8 min
    1. B au filet, A au fond. Point joué normalement.
    2. B gagne le point s'il place une volée gagnante ou force la faute de A.
    3. A gagne le point s'il lobe ou passe B.
    4. Premier à 15 points gagne la série.

    ## Variantes
    - **Faciliter :** A envoie des balles lentes et régulières, sans variation.
    - **Progresser :** A mélange des balles à ses pieds (volée basse) et des lobs courts.
    - **Avancé :** B doit couvrir seul tout le filet (largeur entière), A peut viser les deux couloirs librement.

    ## Récupération — 5 min
    1. Marche lente en respirant profondément (2 min)
    2. Étirement triceps et épaule par-dessus la tête (1 min chaque côté)
    3. Étirement mollets et chevilles appuyés contre le mur (2 min)
  MD
)

Training.create!(
  user: habib,
  chat: chat,
  name: "La Bandeja Chirurgicale",
  training_type: "Smash",
  duration: 75,
  intensity: 8,
  team_size: 4,
  feedback_rating: 8,
  image_url: "https://padelmagazine.fr/wp-content/uploads/2021/03/Twenty-By-Ten-stage-photo-groupe.jpg.webp",
  maestro_conseil: "La bandeja n'est pas un smash — c'est un coup de contrôle. Frappez légèrement en avant du corps avec un mouvement de haut en bas. L'objectif est de forcer la faute par la trajectoire, pas par la puissance.",
  content: <<~MD
    ## Objectif
    Maîtriser la bandeja comme coup de contrôle offensif depuis le filet. Développer la capacité à choisir entre bandeja et vibora selon la hauteur de la balle, et à maintenir la pression sur les défenseurs sans prendre de risques inutiles.

    ## Matériel
    - 30 balles
    - Cônes délimitant les zones cibles (bandes latérales)

    ## Échauffement — 10 min
    1. Jogging et déplacements latéraux sur toute la longueur du court (2 min)
    2. Frappes amorties à la main contre la vitre pour sentir les rebonds (2 min)
    3. Échanges doux en bandeja technique (sans puissance) depuis le milieu du court (4 min)
    4. Étirements épaules, triceps et rotation du tronc (2 min)

    ## Programme

    ### Exercice 1 — Bandeja technique sur balle alimentée — 12 min
    1. Deux joueurs au filet (C1, C2), deux au fond (F1, F2).
    2. F1 lobe en direction de C1 — balle haute et lente.
    3. C1 exécute une bandeja en visant la bande latérale droite avec trajectoire plongeante.
    4. F1 et F2 récupèrent la balle. Rotation après 8 frappes.
    - **Points clés :** épaule non-dominante pointée vers la cible, coude haut au moment du contact, impacter la balle légèrement **en avant** de l'axe du corps.

    ### Exercice 2 — Choix bandeja / vibora — 12 min
    1. Le coach (ou un joueur) lobe depuis le fond avec deux hauteurs différentes : lob haut = bandeja, lob mi-haut = vibora.
    2. Le joueur au filet doit identifier le coup à jouer **avant** que la balle atteigne son sommet.
    3. 3 séries de 10 balles, avec annonce du coup à voix haute avant de frapper.
    - **Points clés :** lecture de trajectoire dès la frappe du lob, prise de décision rapide, ne jamais improviser en suspension.

    ### Exercice 3 — Bandeja sous pression + replacement — 10 min
    1. C1 exécute une bandeja, puis recule immédiatement vers la ligne de service.
    2. F1 défend le coup et renvoie une balle mi-haute.
    3. C1 doit couvrir et enchaîner une 2ème bandeja sans perdre sa position au filet.
    4. La séquence se termine si C1 smash un lob trop court.
    - **Points clés :** replacement rapide après chaque frappe, ne jamais rester planté, coordination avec le partenaire C2.

    ### Exercice 4 — Situation de match (4 joueurs) — 15 min
    1. Match en points joués avec règle : toute balle haute doit être jouée en bandeja (pas de smash direct).
    2. Le smash n'est autorisé qu'après avoir réussi 2 bandejas consécutives dans l'échange.
    3. Premier duo à 21 points gagne.

    ## Variantes
    - **Faciliter :** alimenter les lobes à la main depuis le filet adverse pour rythme plus lent.
    - **Progresser :** le fond peut tenter de passer (passing-shot) au lieu de défendre le lob.
    - **Avancé :** jouer des points où seul le filet peut marquer des points offensifs (fond en survie).

    ## Récupération — 5 min
    1. Bras croisés dans le dos pour ouvrir les pectoraux (1 min)
    2. Rotation lente du tronc assis au sol (1 min chaque côté)
    3. Marche de retour au calme et respiration abdominale (3 min)
  MD
)

Training.create!(
  user: bob,
  chat: chat,
  name: "Le Maître du Slice",
  training_type: "Technique",
  duration: 65,
  intensity: 5,
  team_size: 2,
  feedback_rating: 7,
  image_url: "https://www.setetmatch.net/media/catalog/product/cache/4c28e3904e6a830a72278803d88046d4/2/2/222054-2.jpeg",
  maestro_conseil: "Le slice est une arme défensive et offensive à la fois. Ouvrez la face de raquette juste avant l'impact pour donner un effet coupé maximal. Un bon slice bas oblige l'adversaire à jouer une volée basse difficile à conclure.",
  content: <<~MD
    ## Objectif
    Développer la maîtrise du slice comme outil tactique polyvalent. Apprendre à varier la longueur, l'angle et l'effet pour déséquilibrer l'équipe adverse, forcer les volées basses et créer des opportunités de montée au filet.

    ## Matériel
    - 20 balles
    - Cônes pour délimiter les zones cibles (zone courte devant le filet, zone profonde fond de court)

    ## Échauffement — 10 min
    1. Échanges croisés en coup droit lifté depuis le fond (3 min)
    2. Transition progressive : passer du lift au slice en gardant le même élan (3 min)
    3. Mobilité des poignets : cercles et extensions en tenant la raquette à la gorge (2 min)
    4. Étirements dynamiques des avant-bras et des coudes (2 min)

    ## Programme

    ### Exercice 1 — Slice long vers la vitre — 12 min
    1. A se place au fond côté droit, B au fond côté gauche.
    2. A frappe un slice croisé profond en visant la vitre de fond adverse.
    3. La balle doit rebondir et coller à la vitre — B laisse rebondir et défend en lob.
    4. Alterner les rôles toutes les 10 frappes. Objectif : 7 slices/10 qui touchent la vitre.
    - **Points clés :** ouvrir la face de raquette à 45°, swing de haut en bas, point de contact devant la hanche, accompagnement long du bras.

    ### Exercice 2 — Slice court (drop-slice) — 10 min
    1. A lobe doucement vers B depuis le fond.
    2. B monte au filet et exécute un slice court qui tombe le plus près possible du filet adverse.
    3. La balle doit rebondir deux fois avant la ligne de service.
    4. A doit tenter de rattraper le drop-slice. Si A y arrive, B marque quand même si la volée de A est faible.
    - **Points clés :** balle touchée tôt (avant l'apex), raquette presque à l'horizontale, pas de swing — toucher doux et contrôlé.

    ### Exercice 3 — Alternance long / court — 12 min
    1. A et B échangent en slice, mais A décide à voix haute avant chaque frappe : "long" ou "court".
    2. B doit s'adapter et se repositionner en conséquence.
    3. 4 séries de 8 frappes. Inverse des rôles après chaque série.
    - **Points clés :** lecture de la posture adverse pour anticiper, déplacement avant même l'impact de A, toujours garder une marge sur le filet.

    ### Exercice 4 — Match thématique — 10 min
    1. Points joués normalement mais règle : chaque balle de fond **doit** être jouée en slice.
    2. Si un joueur frappe en lift depuis le fond, le point est perdu automatiquement.
    3. Premier à 15 points gagne la série. Jeu en 2 manches.

    ## Variantes
    - **Faciliter :** pas de contrainte de zone, objectif uniquement de mettre en jeu le slice.
    - **Progresser :** le défenseur peut seulement lober (pas de contre-attaque directe).
    - **Avancé :** enchaîner slice + montée au filet systématique sur chaque coup joué.

    ## Récupération — 5 min
    1. Étirement avant-bras (poignet en extension, 30 sec chaque côté)
    2. Traction légère de la tête vers l'épaule pour détendre le trapèze (1 min)
    3. Marche lente avec respiration contrôlée (3 min)
  MD
)

Training.create!(
  user: habib,
  chat: chat,
  name: "La Diagonale Parfaite",
  training_type: "Tactique",
  duration: 70,
  intensity: 6,
  team_size: 4,
  feedback_rating: 9,
  image_url: "https://padelmagazine.fr/wp-content/uploads/2021/04/Sergio-Alba-bandeja-world-padel-tour.jpg.webp",
  maestro_conseil: "Le padel se joue à travers la diagonale adverse. Ne cherchez pas le coup gagnant direct — créez le déséquilibre avec le croisé, puis concluez avec le long de ligne quand l'espace s'ouvre.",
  content: <<~MD
    ## Objectif
    Comprendre et exploiter la diagonale comme principe tactique fondamental du padel. Développer les automatismes de jeu croisé pour créer des espaces et apprendre à conclure le point au moment opportun avec le long de ligne.

    ## Matériel
    - 25 balles
    - Cônes pour matérialiser les couloirs et les zones de jeu

    ## Échauffement — 10 min
    1. Échanges réguliers à pleine longueur de court, balle dans l'axe (3 min)
    2. Jeu en croisé uniquement, les deux joueurs s'imposent la règle de jeu croisé (3 min)
    3. Sprints courts (5 m) avec retour en position centrale (2 min)
    4. Étirements des hanches et rotation du bassin (2 min)

    ## Programme

    ### Exercice 1 — Construction de la diagonale — 12 min
    1. Équipe A au filet, Équipe B au fond. B joue uniquement en croisé.
    2. A volée en renvoyant dans le couloir opposé (long de ligne).
    3. B doit couvrir et revenir en croisé. L'échange continue jusqu'à la faute.
    4. Rotation des équipes toutes les 6 minutes.
    - **Points clés :** joueur de fond : viser le couloir entre le joueur de filet et le mur ; joueur de filet : ne pas fermer l'angle trop tôt.

    ### Exercice 2 — Le trompe-l'œil (croisé feinté long de ligne) — 12 min
    1. A et B échangent en diagonale depuis le fond.
    2. Après 3 échanges croisés, le 4ème coup peut être joué long de ligne.
    3. Le partenaire doit deviner si le coup sera croisé ou long de ligne et se déplacer en conséquence.
    4. 3 séries de 10 échanges. Comptabiliser les "passes" réussies.
    - **Points clés :** garder la même préparation pour les deux options, ouvrir les épaules au dernier moment, accompagnement de raquette vers la cible.

    ### Exercice 3 — Prise de filet sur diagonale — 10 min
    1. B joue un slice croisé court (drop dans la diagonale).
    2. A monte au filet sur ce drop et exécute une volée en long de ligne.
    3. B court couvrir le long de ligne et défend en lob.
    4. Série de 8 séquences par joueur.
    - **Points clés :** montée au filet en diagonal (ne pas monter en ligne droite), couvrir le contre immédiatement, volée de contrôle avant la volée gagnante.

    ### Exercice 4 — Match avec règle tactique — 15 min
    1. Points joués en 4 contre 4.
    2. Règle : les 3 premiers coups de chaque échange **doivent** être en croisé. Le 4ème peut être n'importe où.
    3. Si un joueur joue long de ligne avant le 4ème coup, le point est perdu automatiquement.
    4. Jeu en 2 sets de 7 jeux.

    ## Variantes
    - **Faciliter :** limiter la règle aux 2 premiers coups seulement.
    - **Progresser :** le fond doit obligatoirement jouer 4 coups croisés avant de conclure.
    - **Avancé :** ajouter la règle que le filet doit poser une volée dans le carré de service avant de smasher.

    ## Récupération — 5 min
    1. Marche lente avec étirement des bras au-dessus de la tête (2 min)
    2. Étirement fléchisseurs de hanche en fente (1 min par côté)
    3. Respiration profonde : inspirez 4 temps, expirez 6 temps (2 min)
  MD
)


puts "Done! #{User.count} users, #{Chat.count} chat, #{Message.count} messages, #{Training.count} trainings."
