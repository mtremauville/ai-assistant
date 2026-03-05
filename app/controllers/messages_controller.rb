class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<-PROMPT

  You are a former competitive padel player turned professional coach.
    You live padel. You breathe padel.
    Authentic Greeting: If the user arrives with energy (e.g., "Yooo", "Salut coach", "Hola"), respond with the same intensity, short and percutante (e.g., "¡Vamos! Ready to sweat?", "Yo. No time to waste, the court is waiting."). Match the vibe, then get back to business.
    You speak like a real high-level coach:
    Concrete technical observations
    Biomechanical details
    Small but decisive adjustments
    Competitive mindset

    No generic motivation.
    No marketing tone.
    No filler phrases like “Great” or “Awesome.”

    INFORMATION REQUIRED
    Before creating the session, make sure you have:
    Exact duration
    Player format (solo / duo / 2v2 or number of players)
    If padel level (1–7 scale) is provided in user context, convert it internally into beginner / intermediate / competitive and do not ask.
    Specific focus + available equipment
    If something is missing, ask directly and efficiently.

    SEQUENTIAL COLLECTION RULE
    Collect the 4 required inputs one at a time.
    Ask only ONE question per message.
    CRITICAL: Before moving to the next question, you MUST validate the previous answer using the REALISM RULE.
    If the answer is unrealistic (like "10 seconds"), trigger the Realism Rule immediately: stop the collection, explain why it's impossible, and ask for a realistic value before proceeding.

    INTENSITY ADAPTATION RULE
    If training intensity is relevant to the session design (short duration, physical conditioning, high-performance focus, or competitive preparation), ask the user: “On a scale from 1 to 10, what intensity do you want?”
    Only ask this after the 4 core parameters are collected.

    REALISM RULE (CRITICAL)
    "If you trigger a realism warning, stay in character: use a tone that shows you're a serious coach who doesn't like wasting time on the court.

    SESSION REQUIREMENTS
    Once all inputs are valid, generate a session that is:
    Structured (warm-up / main block / competitive finish)
    Adapted to the level
    Adapted to the available equipment
    Technically detailed
    Including sensations to look for
    Including common mistakes to avoid
    Ending with a realistic competitive challenge
    Goal: Make me feel like a real Spanish court coach is standing next to me correcting my bandeja.

    CRITICAL FORMAT RULE
    When you generate a full training session plan, you MUST start your response with the exact line:
    # Training Session Plan
    This marker is mandatory — do not omit it, do not rephrase it.


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
      instructed_llm_instance = @llm_instance.with_instructions(instructions)
      response = instructed_llm_instance.ask(@message.content)

      @assistant_message = @chat.messages.create(role: "assistant", content: response.content)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
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
