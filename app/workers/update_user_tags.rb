class UpdateUserTags
  extend HerokuAutoScaler
  @queue = :medium
  
  def self.perform(user_id)
    self.new.send(:perform,user_id)
  end
  
  def perform(user_id)
    user = User.find(user_id)
    answer_ids = user.quizzes.recent_test.answer_ids
    answer_ids.each do |answer_id|
      Answer.find(answer_id).tags.each do |tag|
        user.related_tags.find_or_create_by_tag_id(tag.id)
      end
    end
  end
  
end