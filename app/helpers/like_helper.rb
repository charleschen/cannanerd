module LikeHelper

  def like_link_for(target)
    link_to "like it", like_path(:resource_name => target.class, :resource_id => target.id), :method => :post, :remote => false
  end

  def unlike_link_for(target)
    link_to "unlike it", like_path(:resource_name => target.class, :resource_id => target.id), :method => :delete, :remote => false
  end

  def likeable_links(target)
    if current_user && permitted_to?(:create,:likes)
      if current_user.likes? target
        unlike_link_for(target)
      else
        like_link_for(target)
      end
    end
  end
  
  def likeablebox target
    content_tag :div, :id => 'likebox' do
      render 'shared/like', :target => target
    end
  end
end