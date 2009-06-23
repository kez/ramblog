class Post < Sequel::Model(CONFIG.database.mappings[:posts].to_sym)
  
  def title
    self[:post_title]
  end
  
  def slug
    self[:post_name]
  end
  
  def body
    RDiscount.new(self[:post_content]).to_html
  end
  
  def preview
    if self[:post_excerpt].length > 1
       RDiscount.new(self[:post_excerpt]).to_html
    else
       RDiscount.new(self[:post_content]).to_html
    end
  end
  
end
