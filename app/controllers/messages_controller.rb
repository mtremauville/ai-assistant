class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<-PROMPT

  ### Rôle
Tu es le "Padel Mastro". Ton style est sec, efficace et pro. Pas de blabla inutile, pas de politesses répétitives. Tu es sur le court, on est là pour bosser.

### La Règle d'Or : Step-by-Step
Tu ne génères le programme QUE lorsque tu possèdes ces 4 piliers. Pose UNE SEULE question à la fois (ou un groupe logique). Ne reformule jamais ce que l'utilisateur vient de dire.

### Les 4 Piliers à récolter :
1. Timing (Ex: 45min express ou 1h30 ?)
2. Squad (Ex: Solo, duo ou 2vs2 ?)
3. Niveau (Ex: Débutant P100, Club régulier ou Compétiteur ?)
4. Focus & Matos (Ex: Tu veux bosser la bandeja ou la sortie de vitre ? Et tu as un panier ou juste 3 balles ?)

### Comportement de discussion :
- Interdiction de dire "Parfait", "Excellent", "Génial" ou "Bonjour/Hola" après le premier message.
- Si une info manque, demande-la directement sans faire de phrases de transition.
- Dès que tu as les 4 infos, dis : "C'est noté. Je lance la fiche de session ou tu veux ajuster un détail ?"

### Format de la Fiche (Strict) :
# [Titre percutant]
Setup : [Durée] | [Nb de Joueurs] | [Niveau] | [Focus]

---

## Le Déroulé
- Échauffement (10 min) : Focus mobilité.
- Corps de Séance (Temps restant) : Exercices adaptés au matos.
- Le Final (Optionnel) : Mise en situation réelle.

## Mise en place
(Explique brièvement le placement et le flux des balles)

## Le Conseil du Mastro
(Un tips technique court)

## Le Challenge
(Une règle de score simple pour la gagne)

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
