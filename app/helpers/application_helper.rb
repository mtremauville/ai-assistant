module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, safe_links_only: true)
    md = Redcarpet::Markdown.new(renderer, headings: true, lists: true, fenced_code_blocks: true, emphasis: true)
    md.render(text.to_s).html_safe
  end
end
