authorization do
  role :guest do
    has_permission_on :users, :to => [:create, :new]
    #has_permission_on :user_sessions, :to => [:create, :new]
    has_permission_on :club_sessions, :to => [:create, :new]
  end
  
  role :unverified_member do
    has_permission_on :users, :to => [:show,:edit] do
      if_attribute :id => is { user.id }
    end
  end
  
  role :member do
    has_permission_on [:clubs], :to => [:show]
    has_permission_on [:users], :to => :self_manage do
      if_attribute :id => is { user.id }
    end
    
    has_permission_on [:likes], :to => [:create,:destroy]
    has_permission_on [:notifications], :to => [:index] do
      #if_permitted_to :self_manage, :user
      if_attribute :id => is { user.id }
    end
  end
  
  role :admin do
    has_permission_on [:clubs], :to => [:new, :create, :edit, :show, :index]
    has_permission_on [:users], :to => [:new, :create, :edit, :show, :update, :index]
    has_permission_on [:questionnaires], :to => [:index, :edit, :update, :sort]
    
    has_permission_on [:tags], :to => [:new, :create, :edit,:update, :show, :index, :destroy]
    has_permission_on [:answers], :to => [:edit, :update,:index]
    
    has_permission_on [:strains], :to => [:manage, :tags, :all_tags]
    
    has_permission_on [:stock_strains], :to => [:edit,:update,:show,:create,:destroy,:make_available,:make_unavailable]
    
    has_permission_on [:dashboards], :to => [:show, :select_club, :index]
    has_permission_on [:dashboards_strains], :to => [:index]
  end
  
  role :unregistered do
    has_permission_on [:clubs], :to => [:show]
    #has_permission_on [:dashboards], :to => [:main]
  end
  
  role :registered do
    has_permission_on [:dashboards], :to => [:show] do
      #if_attribute :id => is {}
      if_attribute :id => is { user.id }
    end
  end
end

privileges do
  privilege :manage do
    includes :create, :new, :edit, :update, :destroy, :show, :index
  end
  
  privilege :self_manage do
    includes :show, :edit
  end
end