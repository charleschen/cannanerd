authorization do
  role :guest do
    has_permission_on :users, :to => [:create, :new]
  end
  
  role :unverified_member do
    has_permission_on :users, :to => [:show,:edit] do
      if_attribute :id => is { user.id }
    end
  end
  
  role :member do
    has_permission_on [:clubs], :to => [:show]
    has_permission_on [:users], :to => [:show,:edit] do
      if_attribute :id => is { user.id }
    end
  end
  
  role :admin do
    has_permission_on [:clubs], :to => [:new, :create, :edit, :show, :index]
    has_permission_on [:users], :to => [:new, :create, :edit, :show, :index]
    has_permission_on [:questionnaires], :to => [:index, :edit, :update, :sort]
    
    has_permission_on [:tags], :to => [:new, :create, :edit,:update, :show, :index, :destroy]
    has_permission_on [:answers], :to => [:edit, :update,:index]
    
    has_permission_on [:strains], :to => :manage
    
    has_permission_on [:stock_strains], :to => [:show,:create,:destroy]
  end
  
  role :unregistered do
    has_permission_on [:clubs], :to => [:show]
  end
  
  role :registered do
    
  end
end

privileges do
  privilege :manage do
    includes :create, :new, :edit, :update, :destroy, :show, :index
  end
end