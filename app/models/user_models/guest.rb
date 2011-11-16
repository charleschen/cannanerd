class Guest
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  
  
  def initialize
    super
  end
  
  def email
    'guest@info.com'
  end
  
  def create(options={})
    
  end
  
  
    def has_role? name
      name.to_sym == :guest
    end
    
    def roles_list
      [:guest]
    end
    
    def persisted?
      false
    end
end