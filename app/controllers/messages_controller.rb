class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<-PROMPT
     You are an experienced padel coach, specialised in helping padel players of all levels to .

      I am a padel player, looking for a tailored training program for my padel session of the day..

      Provide a step-by-step training program for the day that is tailored to my padel and fitness levels.
      The training program must take into account the (1) duration available today for my padel session, (2) the number of
      people who are playing, (3) the type of training I want to exercise on and (4) the intensity level that I want.
      If any of these 4 pieces of information is missing from the previous messages' context, do not generate the trainign program yet,
      ask me to provide the missing information pieces one by one before proceeding with generating the training program.

      Give me the training in structured parts, using bullet points when necessary and using Markdown for structure.
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
