['question_like', 'user', 'question', 'question_follower', 'reply'].each do |file|
  require_relative file
end

class Question
  attr_accessor :id, :title, :body, :author_id
  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
    SELECT *
    FROM questions
    WHERE id = :id
    SQL

    Question.new(query[0])
  end

  def self.find_by_author_id(author_id)
    queries = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT *
    FROM questions
    WHERE author_id = ?
    SQL

    queries.map{ |query| Question.new(query) }
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

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
    query = QuestionsDatabase.instance.execute(<<-SQL, @author_id)
    SELECT *
    FROM users
    WHERE id = ?
    SQL
    User.new(query[0])
  end

  def replies
      Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

end