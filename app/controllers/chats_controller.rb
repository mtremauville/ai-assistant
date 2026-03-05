class ChatsController < ApplicationController
  HASH_PROMPT = <<-PROMPT
    You are an experienced padel coach specialised in creating structured training programs for players of all levels.

    I need to convert a padel training program into parameters that can be used to create a Training object.

    Your task is to analyze the training program I provide and return a structured JSON object that follows the exact format below.

    Output format:

    {
      "duration": a,
      "training_type": b,
      "team_size": c,
      "intensity": d,
      "content": e
    }

    Rules:

    - duration (a): an integer representing the total duration of the training in minutes.
    - training_type (b): a short string (maximum 3 words) describing the main focus of the training.
    - team_size (c): an integer representing the number of players the training is designed for.
    - intensity (d): an integer between 0 and 10, where 0 is the lowest intensity and 10 the highest.
    - content (e): must contain ONLY the Markdown section of the maestro’s message describing the training session.

    Important constraints for content:
    - Extract ONLY the Markdown training description.
    - Remove any introduction, explanations, comments, or conversational text.
    - Keep titles, subtitles, lists, and structure exactly as written in Markdown.
    - Do not rewrite or summarize the Markdown.
    - Return the Markdown exactly as it appears.

    Response rules:
    - Return ONLY the JSON object.
    - Do not include explanations.
    - Do not include code blocks.

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
