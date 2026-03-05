class ChatsController < ApplicationController
  HASH_PROMPT = <<-PROMPT
      # You are an experienced padel coach, specialised in helping padel players of all levels.

      # I am a padel player who received a training program, and I'm looking to convert it into a list of parameters of the right format
      # to use in my application.

      # Transform the training program into a hash that can be used directly in an application as parameters to create an instance of a Training object in ruby

      # The format of the response should be like a JSON with the following key value pairs:
      # duration: a, training_type: b, team_size: c, intensity: d, content: e
      # Where:
      #  - a is an integer, and is the number of minutes that the training program lasts in total
      #  - b is a short strign of max 3 words that describe the focus of the training
      #  - c is an integer of the number of people for which this training is for
      #  - d is an integer between 0 and 10 that evaluates the intensity, with highest intensity being 10 and lowest intensity being 0
      #  - e is a long text, containing ONLY the markdown-formatted part of the message sent by me (the user),
      #  meaning only the sections with markdown headings (lines starting with # or ##) and their content.
      #  Do NOT include any introductory sentences, closing remarks, or plain text that appears before or after the markdown block.
  PROMPT

  def create
    @chat = Chat.new(title: "New chat")
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      render "trainings/index"
    end
  end

  def show
    @chat    = current_user.chats.find(params[:id])
    @message = Message.new
    @chats   = current_user.chats.order(created_at: :desc).limit(5)
  end

  def generate_training
    # get the last message
    @chat = current_user.chats.find(params[:id])
    last_message = @chat.messages.last

    llm_instance = RubyLLM.chat
    #  give prompt context to the llm instance
    instructed_llm_instance = llm_instance.with_instructions(HASH_PROMPT)
    #  then give it the content of the user message to generate an adequate answer
    response = instructed_llm_instance.ask(last_message.content)
    parsed = JSON.parse(response.content)
    new_training = Training.new(parsed)

    # set default feedback rating
    new_training.feedback_rating = 10

    new_training.user = current_user
    new_training.chat = @chat
    new_training.save!

    redirect_to trainings_path
  end
end
