class ChatsController < ApplicationController
  HASH_PROMPT = <<-PROMPT
      You are an experienced padel coach, specialised in helping padel players of all levels.

      I am a padel player who received a training program, and I'm looking to convert it into a list of parameters of the right format to use in my application.

      Transform the training program into a JSON object with the following keys:
      duration, training_type, team_size, intensity, content, maestro_conseil

      Where:
      - duration: an integer, the total number of minutes the training lasts
      - training_type: a short string of max 3 words describing the focus of the training
      - team_size: an integer, the number of people this training is designed for
      - intensity: an integer between 0 and 10 (0 = lowest, 10 = highest intensity)
      - content: a rich, detailed markdown document built from the training program.
        Structure it with the following sections (## for main sections, ### for sub-sections):

        ## Objectif
        2-3 sentences explaining what this session trains and why it matters tactically.

        ## Matériel
        Bullet list of required equipment (only if specific gear beyond racket/ball is needed).

        ## Échauffement — X min
        Numbered list of 3-5 warm-up exercises with brief instructions and durations.

        ## Programme
        For each exercise block, use a ### sub-heading with the exercise name and duration.
        Under each sub-heading: numbered steps for execution, then a bullet list of "Points clés" (2-3 coaching cues).
        Include at least 3-4 exercise blocks with enough detail to fill 1-2 paragraphs each.

        ## Variantes
        Bullet list of 2-3 progressions or difficulty adjustments (easier / harder versions).

        ## Récupération — X min
        Short numbered list for cool-down stretches or light exercises.

        Use numbered lists for sequential steps and bullet lists (- ) for tips or options.
        Be thorough and specific — a coach reading this should be able to run the session without guessing.
        Do NOT include any introductory sentences or closing remarks outside the markdown structure.
      - maestro_conseil: a short motivational advice from you, personalized based on the training content,
        in the same language as the training content, max 2 sentences.

      IMPORTANT: Return ONLY raw JSON, with no markdown code blocks, no ```json, no ``` — just the JSON object.
  PROMPT

  def create
    @chat = Chat.new(title: "New chat")
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat), notice: flash[:notice]
    else
      render "trainings/index"
    end
  end

  def show
    @chat    = current_user.chats.find(params[:id])
    @message = Message.new
    clean
    @chats = current_user.chats.order(created_at: :desc).limit(5)
    last_assistant = @chat.messages.where(role: "assistant").last
    @chips = last_assistant ? generate_chips(last_assistant.content) : []
  end

  def destroy
    @chat = current_user.chats.find(params[:id])
    @chat.destroy
    render turbo_stream: turbo_stream.remove("sidebar-chat-wrap-#{@chat.id}")
  end

  def generate_training
    @chat = current_user.chats.find(params[:id])
    parsed = parse_training_from_llm(@chat.messages.last.content)

    new_training = Training.new(parsed)
    new_training.feedback_rating = 10
    new_training.user = current_user
    new_training.chat = @chat
    new_training.save!

    redirect_to trainings_path
  end

  TRAINING_KEYS = %w[duration training_type team_size intensity content maestro_conseil].freeze

  private

  def clean
    current_chat = current_user.chats.find(params[:id])
    chats = current_user.chats
    chats.each do |chat|
      chat.destroy if chat.messages.empty? && chat != current_chat
    end
  end

  def parse_training_from_llm(message_content)
    response = RubyLLM.chat.with_instructions(HASH_PROMPT).ask(message_content)
    json_str = response.content.gsub(/\A```(?:json)?\n?/, "").gsub(/\n?```\z/, "").strip
    JSON.parse(json_str).slice(*TRAINING_KEYS)
  end
end
