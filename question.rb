require_relative 'questions_db'
require_relative 'question_follower'
require_relative 'user'

class Question
  
  def self.find_by_id(id)
    question_query = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT 
        *
      FROM 
        questions
      WHERE 
        id = :id
      SQL

    Question.new(question_query)
  end

  def self.find_by_author_id(author_id)
    questions_query = QuestionsDatabase.execute(<<-SQL, author_id: author_id)
      SELECT 
        *
      FROM 
        questions
      WHERE 
        author_id = :author_id
      SQL

    questions_query.map{ |query| Question.new(query) }
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  attr_accessor :id, :title, :body, :author_id

  def initialize(options = {})
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likers
    QuestionLike.num_likes_for_question_id(@id)
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

end