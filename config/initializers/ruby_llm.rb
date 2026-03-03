require "ruby_llm"

RubyLLM.configure do |config|
  # If using Paid open ai token
  # config.openai_api_key = ENV["OPENAI_API_KEY"]

  # If using Azuer github sandbox free token
  config.openai_api_key = ENV["GITHUB_TOKEN"]
  config.openai_api_base = "https://models.inference.ai.azure.com"
end
