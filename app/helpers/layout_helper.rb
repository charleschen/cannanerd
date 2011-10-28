module LayoutHelper
  def title(page_title)
    content_for(:title) {"CannaNerd | #{page_title.to_s}"}
  end
  
  def subtitle(page_subtitle)
    content_for(:subtitle) {page_subtitle}
  end
end