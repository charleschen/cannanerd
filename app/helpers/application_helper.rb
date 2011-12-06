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
  
  def tag_types
    [:flavors,:types,:conditions,:symptoms,:effects,:prices]
  end
  
  def render_multi_column_answers(f,quiziation,answers, cols=2)
    returning (rendered="") do
      answers.in_groups_of((answers.count/(cols+0.0)).ceil) do |group|
        rendered << %{ <div class='narrow-col'><ul>}
        group.each do |answer|
          unless answer.nil?
            answer_field = f.fields_for :quiziations, quiziation do |builder|
              content = ""
              content << "<li class='small'>" 
              content <<  builder.check_box(:checked_answers,{},"answer_#{answer.id};1","answer_#{answer.id};0") 
              content <<  answer.content 
              content << "</li>"
              content.html_safe
            end
            rendered << answer_field
          end
        end
        rendered << %{ </ul></div> }
      end
    end
  end
end
