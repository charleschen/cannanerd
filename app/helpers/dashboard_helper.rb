module DashboardHelper
  def dash_path(path_sym=nil)
    id = current_user.id if current_club
    id = params[:id] if permitted_to?(:select_club, :dashboards)
    if path_sym
      #"#{dashboard_path}/#{id}/#{path_sym.to_s}"
      "#{dashboards_path}/#{id}/#{path_sym.to_s}"
    else
      #"#{dashboard_path}/#{id}"
      "#{dashboards_path}/#{id}"
    end
  end
  
  def has_club_id?
    curr_path =~ /dashboards\/[0-9]+/
  end
  
  def club_id_param
    curr_path[/dashboards\/([0-9]+)/,1]
  end
  
  def curr_club
    Club.find(params[:id])
  end
  
  def if_current_controller(controller, action=params[:action])
    "class='current'" if params[:controller] == controller && params[:action] == action
  end
  
  def tag_with_current_class(tag, controller, action=params[:action])
    if params[:controller] == controller && params[:action] == action
      "<#{tag} class='current'>".html_safe
    else
      "<#{tag}>".html_safe
    end
  end
end