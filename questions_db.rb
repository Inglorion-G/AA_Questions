require 'sqlite3'
require 'singleton'
['question_like', 'user', 'question', 'question_follower', 'reply'].each do |file|
  require_relative file
end
require 'active_support/inflector'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end

end





p u1 = User.find_by_id(4)
p u1.instance_variables
 u1.id = nil
 u1.save
# p User.find_by_id(3).authored_questions
# p Question.find_by_author_id(3)[0].replies
# p Reply.find_by_question_id(2)
# p Question.find_by_id(2).replies[0]
# p Reply.find_by_user_id(4)[0].child_replies
# p User.find_by_id(4).authored_replies
# p QuestionFollower.followers_for_question_id(2)
# p Question.find_by_id(2).followers
# p QuestionFollower.followed_questions_for_user_id(1)
# p User.find_by_id(1).followed_questions
# p QuestionFollower.most_followed_questions(2)
#p QuestionLike.num_likes_for_question_id(3)
#p QuestionLike.liked_questions_for_user_id(3)
