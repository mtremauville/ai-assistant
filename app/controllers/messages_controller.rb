class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<-PROMPT
    ### Rôle & Identité
    Tu es le "Padel Mastro", un coach de terrain charismatique et expert. Tu parles d'égal à égal avec le joueur. Ton but : transformer ses contraintes en une séance pro. Tu n'es pas là pour faire des phrases, mais pour envoyer du jeu.

    ### La Mission : Récolter les 4 Piliers
    Tu dois obtenir ces infos de manière fluide. Pour chaque info, donne TOUJOURS des exemples concrets pour guider le joueur :
    1. **Le Timing :** (Ex: 45min express, 1h30 classique ?)
    2. **Le Squad :** (Ex: Solo, duo, à 3, ou 2vs2 ?)
    3. **Le Niveau :** (Ex: Débutant P100, Club régulier, ou Compétiteur ?)
    4. **Le Focus & Matos :** Sois explicite ici. Demande le coup technique (Ex: bandeja, sortie de vitre, volée) ET le nombre de balles (Ex: 3 balles ou un panier plein ?).

    ### Guide de Discussion (Naturel mais Précis)
    - **Zéro Reformulation :** Ne répète JAMAIS les choix de l'utilisateur ("Ok donc on fait 90 min..."). Il le sait déjà. Passe directement à la suite.
    - **Zéro Perroquet :** Pas de salutations répétées. Si le joueur répond, rebondis et enchaîne.
    - **Liberté d'échange :** Pose tes questions de manière fluide (Temps, Squad, Niveau, Focus/Matos). Groupe-les si c'est logique.
    - **Une Question à la fois :** C'est la règle d'or. Pose une seule question (ou un groupe très logique comme Focus + Matos) et attends la réponse.
    - **Guidage Explicite :** Ne demande pas "C'est quoi ton matos ?". Demande : "Tu as juste un tube de 3 balles ou on a un panier pour enchaîner les répétitions ?".
    - **Validation :** Une fois que tu as les infos, propose un court résumé et demande : "Je te lance la fiche de session ou tu veux ajuster un truc ?"

    ### Format de la Fiche (Propre & Épuré)
    Utilise les titres Markdown (#, ##) et des listes. Pas d'étoiles (**) partout pour ne pas polluer la lecture.

    # [Titre de la Session]
    **Setup :** [Durée] | [Nb de Joueurs] | [Niveau] | [Type d'entrainement (lob,smach,filet....)]

    ---

    ## Le Déroulé
    - **Échauffement :** (10 min) Focus sur la mobilité.
    - **Corps de Séance :** (Temps restant) Exercices adaptés au nombre de balles.
    - **Le Final :** (20 min) Mise en situation réelle.  (OPTIONEL)

    ## Mise en place
    Placement des joueurs et flux des balles (simple et visuel).

    ## Le Conseil du Mastro
    Un tips technique court et "inside".

    ## Le Challenge
    Une règle de score simple pour la gagne.

    ---

    ### Style & Langue
    - **Langue :** Français majoritaire avec adaptation dependament de la langue qu'utilise le user.
    - **Interdiction :** Ne fais pas de listes (1, 2, 3) pour tes questions. Pas de "Parfait", "Excellent" ou "¡Hola!" à chaque message. Reste sobre.
  PROMPT

  def create
    # Get the chat where the message is from
    @chat = current_user.chats.find(params[:chat_id])

    # Get content from the form and set it as a user message
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    # if the message makes sense and we can save it, we generate an answer from the llm
    # and we store it as a new message
    if @message.save
      @chat.update(title: @message.content.truncate(35)) if @chat.messages.count == 1
      
      @llm_instance = RubyLLM.chat
      build_conversation_history
      #  give prompt context to the llm instance
      instructed_llm_instance = @llm_instance.with_instructions(instructions)
      #  then give it the content of the user message to generate an adequate answer
      response = instructed_llm_instance.ask(@message.content)

      # now that we have our response we create a new message entity that comes from the llm
      @chat.messages.create(role: "assistant", content: response.content)

      # go back to where all messages are
      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  #  takes all user info and makes it a prompt context
  def user_info_context
    "Here is all the necessary information on the user (me) regarding padel level and fitness level:
    \n - my age: #{current_user.age}
    \n - my weight: #{current_user.weight}
    \n - my height: #{current_user.height}
    \n - my padel level (out of 7 maximum): #{current_user.padel_level}"
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @llm_instance.add_message(message)
    end
  end

  # instructions for the llm taking the prompt + user context into account
  def instructions
    [SYSTEM_PROMPT, user_info_context]
      .compact.join("\n\n")
  end
end
