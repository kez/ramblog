# Default url mappings are:
#  a controller called Main is mapped on the root of the site: /
#  a controller called Something is mapped on: /something
# If you want to override this, add a line like this inside the class
#  map '/otherurl'
# this will force the controller to be mounted on: /otherurl

class MainController < Controller
  # the index action is called automatically when no other action is specified
  def index slug = nil, page = 1

    # select * from wp_term_relationships a inner join wp_term_taxonomy b on a.term_taxonomy_id = b.term_taxonomy_id inner join wp_terms c on b.term_id = c.term_id where object_id=99;


    if slug == "page" or slug == nil
      @offset = page.to_i
    
      @posts = Post.filter(:post_status => 'publish').filter(:post_type => 'post').order(:post_date.desc).paginate(@offset, 10)
    
    
    elsif slug != nil
        @post = Post[:post_name => slug]
        @title = CONFIG.blog.name + " - " + @post.title
    end
    
  end

  # the string returned at the end of the function is used as the html body
  # if there is no template for the action. if there is a template, the string
  # is silently ignored
  def notemplate
    "there is no 'notemplate.xhtml' associated with this action"
  end
end
