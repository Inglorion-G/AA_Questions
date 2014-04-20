require 'question'
require 'questions_db'
require 'user'

class Reply
  def self.find_by_id(id)
    reply_query = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT 
        *
      FROM 
        replies
      WHERE 
        replies.id = :id
    SQL

    Reply.new(reply_query)
  end
  
  def self.find_by_parent_id(parent_id)
    reply_queries = QuestionsDatabase.execute(<<-SQL, parent_reply_id: parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_reply_id = :parent_reply_id
    SQL
    
    reply_queries.map { |query| Reply.new(query) }

  def self.find_by_user_id(user_id)
    reply_queries = QuestionsDatabase.execute(<<-SQL, user_id: user_id)
      SELECT 
        *
      FROM 
        replies
      WHERE 
        replies.user_id = :user_id
    SQL

    reply_queries.map{ |query| Reply.new(query) }
  end

  def self.find_by_question_id(question_id)
    reply_queries = QuestionsDatabase.execute(<<-SQL, question_id: question_id)
      SELECT 
        *
      FROM 
        replies
      WHERE 
        replies.question_id = :id
    SQL

    reply_queries.map { |query| Reply.new(query) }
  end
  
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @parent_reply_id = options["parent_reply_id"]
    @user_id = options["user_id"]
    @body = options["body"]
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_parent_id(@parent_reply_id)
  end

  def child_replies
    Reply.find_by_parent_id(@id)
  end

end