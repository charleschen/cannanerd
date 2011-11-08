require 'declarative_authorization'

authorization do
  role :admin do
    has_permission_on [:clubs], :to => [:new, :create, :index]
  end
  
  role :guest do
    
  end
end