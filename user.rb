require_relative 'question'
require_relative 'questions_db'
require_relative 'question_follower'

# class TableSaver
#   def save
# 
#     p instance_values = self.instance_variables.map do |instance_variable|
#       instance_variable.to_s
#     end
#     p questions = ("?"*instance_values.length).split(//).join(', ')
# 
#     p table_name = self.class.to_s.downcase.pluralize
# 
#     p column_names = instance_values.dup.map do |instance_value|
#       instance_value.to_s[1,-1]
#     end
# 
#     @id = QuestionsDatabase.last_insert_row_id
#   end
# end

class User

  def self.find_by_id(id)
    user_query = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT 
        *
      FROM 
        users
      WHERE 
        users.id = :id
    SQL
    
    User.new(user_query)
  end

  def self.find_by_name(fname, lname)
    user_query = QuestionsDatabase.get_first_row(<<-SQL, fname: fname, lname: lname)
      SELECT 
        *
      FROM 
        users
      WHERE 
        users.fname = :fname AND users.lname = :lname
    SQL

    User.new(user_query)
  end

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

  def average_karma
    QuestionsDatabase.get_first_value(<<-SQL, author_id: @id)
      SELECT 
        COUNT(l.id) / CAST(COUNT(DISTINCT(q.id)) AS FLOAT)
      FROM
        questions q
      LEFT OUTER JOIN
        question_likes l
      ON
        q.id = l.question_id
      WHERE
        q.author_id = :author_id
    SQL
  end

end
