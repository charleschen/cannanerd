module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + button_to_function(name, "remove_fields(this)", :id => "delete_#{f.object_name}")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    button_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')")
  end
  
  def logo
    image_tag('logo.jpeg',:alt => 'Cannanerd')
  end
  
  def javascript(*files)
    content_for(:javascript) { javascript_include_tag(*files)}
  end
end
