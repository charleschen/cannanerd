authorization do
  role :guest do
    has_permission_on :users, :to => [:create, :new]
  end
  
  role :unverified_member do    # 
      # has_permission_on [:user], :to => [:edit] do
      #   if_attribute :user => { user }
      # end
    has_permission_on :users, :to => [:edit] do
      if_attribute :user => contains { user }
    end
  end
  
  role :member do
    has_permission_on [:clubs], :to => [:show]
    has_permission_on [:users], :to => [:show] do
      if_attribute :id => is { user.id }
    end
  end
  
  role :admin do
    has_permission_on [:clubs], :to => [:new, :create, :edit, :show, :index]
    has_permission_on [:users], :to => [:new, :create, :edit, :show, :index]
    has_permission_on [:questionnaires], :to => [:index, :edit, :update]
    
    has_permission_on [:tags], :to => [:new, :create, :edit,:update, :show, :index, :destroy]
    has_permission_on [:answers], :to => [:edit, :update,:index]
  end
  
  role :unregistered do
    has_permission_on [:clubs], :to => [:show]
  end
  
  role :registered do
    
  end
end