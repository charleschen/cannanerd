require 'declarative_authorization'

authorization do
  role :guest do
    
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
    has_permission_on [:clubs], :to => [:index]
  end
  
  role :admin do
    has_permission_on [:clubs], :to => [:new, :create]
    has_permission_on [:users], :to => [:new, :create, :edit]
  end
  
  role :unregistered do
    
  end
  
  role :registered do
    
  end
end