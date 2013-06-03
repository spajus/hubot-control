module ApplicationHelper

  def feedback(good, good_text = '', bad_text = '', &block)
    if good
      css_class = 'green'
      text = good_text
    else
      css_class = 'red'
      text = bad_text
    end
    in_span(css_class, text, &block)
  end

  def in_span(css_class, text = '', &block)
    content = block_given? ? capture(&block) : text.to_s
    content_tag :span, content, class: css_class
  end

end
