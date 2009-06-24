# Default url mappings are:
#  a controller called Main is mapped on the root of the site: /
#  a controller called Something is mapped on: /something
# If you want to override this, add a line like this inside the class
#  map '/otherurl'
# this will force the controller to be mounted on: /otherurl

class MainController < Controller
  # the index action is called automatically when no other action is specified
  def index arg1 = nil, arg2 = 1, arg3 = nil, arg4 = nil

    # select * from wp_term_relationships a inner join wp_term_taxonomy b on a.term_taxonomy_id = b.term_taxonomy_id inner join wp_terms c on b.term_id = c.term_id where object_id=99;


    if arg1 == "page" or arg1 == nil
      @title = CONFIG.blog.name
      
      @offset = arg2.to_i
      @page_count = (Post.select(:ID).filter(:post_status => 'publish').filter(:post_type => 'post').count / CONFIG.blog.posts_per_page.to_i) + 1
    
      @posts = Post.filter(:post_status => 'publish').filter(:post_type => 'post').order(:post_date.desc).paginate(@offset, CONFIG.blog.posts_per_page.to_i)
      
    elsif arg1 == "tag" and arg2 != nil
     
      @title = CONFIG.blog.name + " - Posts tagged with \"#{arg2}\""
      
      @posts = Post.fetch("SELECT * FROM wp_posts INNER JOIN wp_term_relationships on wp_posts.ID = wp_term_relationships.object_id INNER JOIN wp_term_taxonomy on wp_term_relationships.term_taxonomy_id = wp_term_taxonomy.term_taxonomy_id INNER JOIN wp_terms ON wp_term_taxonomy.term_id = wp_terms.term_id WHERE wp_terms.slug = '#{arg2}' AND wp_term_taxonomy.taxonomy = 'post_tag' AND wp_posts.post_status = 'publish' and wp_posts.post_type = 'post' ORDER BY wp_posts.post_modified DESC").all
   
    elsif arg1 != nil and @post = Post[:post_name => arg1]
        @title = CONFIG.blog.name + " - " + @post.title
        
        @comment = Comment.new
        
        if request.post?
          Ramaze::Log.debug request.params["REMOTE_ADDR"]
          
          if check_captcha(request[:simple_captcha])
          
            @comment[:comment_author] = request[:author_name]
            @comment[:comment_post_ID] = request[:post_id]
            @comment[:comment_author_email] = request[:author_email]
            @comment[:comment_author_url] = request[:author_url]
            @comment[:comment_author_IP] = "127.0.0.1"
            @comment[:comment_date] = Time.now
            @comment[:comment_date_gmt] = Time.now
            @comment[:comment_content] = request[:author_comment]
          
            if @comment.save
              @post[:comment_count] += 1
              @post.save
              
              flash[:message] = "Thanks for the comment"
            else
              Ramaze::Log.error "Error saving comment"
              Ramaze::Log.error @comment
            end
            
            
          else
            flash[:error] = "Please complete the Captcha question"
          end
          
        end
        
        
    elsif arg1 != nil and @post != Post[:post_name => arg1]
      'oh noes'
    end
    
  end

  # the string returned at the end of the function is used as the html body
  # if there is no template for the action. if there is a template, the string
  # is silently ignored
  def notemplate
    "there is no 'notemplate.xhtml' associated with this action"
  end
  
  def error
    Ramaze::Log.debug 'oh no!'
    'oh no'
  end
  
  def post_comment
    
  end
  
    
  
end
