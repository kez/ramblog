require 'model/comment'
require 'model/term'

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
  
  def comments
    Comment.select(:comment_ID, :comment_author, :comment_author_email, :comment_author_url, :comment_date, :comment_content).filter(:comment_post_ID => self[:ID], :comment_approved => 1).order(:comment_date.desc).all
  end
  
  def tags
    tag = Term.fetch("SELECT name, slug FROM wp_terms INNER JOIN wp_term_taxonomy on wp_terms.term_id = wp_term_taxonomy.term_id INNER JOIN wp_term_relationships ON wp_term_taxonomy.term_taxonomy_id = wp_term_relationships.term_taxonomy_id WHERE wp_term_relationships.object_id = #{self[:ID]} AND wp_term_taxonomy.taxonomy = 'post_tag'").all  
  end
  
  def content
    RDiscount.new(self[:post_content]).to_html
  end
  
end
