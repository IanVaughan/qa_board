class TextRender
  def render_text_board
    text = ''
    @@phase.data.each do |phase, details|
      text << render_text(phase)
      text << "\n"
    end
    text
  end
end
