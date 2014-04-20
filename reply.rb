['question_like', 'user', 'question', 'question_follower', 'reply'].each do |file|
  require_relative file
end

class Reply
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body
  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
    SELECT *
    FROM replies
    WHERE id = :id
    SQL

    Reply.new(query[0])
  end

  def self.find_by_user_id(user_id)
    queries = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT *
    FROM replies
    WHERE user_id = ?
    SQL

    queries.map{ |query| Reply.new(query) }
  end

  def self.find_by_question_id(id)
    queries = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM replies
    WHERE question_id = ?
    SQL

    queries.map { |query| Reply.new(query) }
  end

  def author
    queries = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
    SELECT *
    FROM users
    WHERE id = ?
    SQL

    queries.map { |query| User.new(query) }
  end

  def question
    queries = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
    SELECT *
    FROM questions
    WHERE id = ?
    SQL

    queries.map { |query| Question.new(query) }
  end

  def parent_reply
    queries = QuestionsDatabase.instance.execute(<<-SQL, @parent_reply_id)
    SELECT *
    FROM replies
    WHERE id = ?
    SQL

    queries.map { |query| Reply.new(query) }
  end

  def child_replies
    queries = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
    SELECT *
    FROM replies
    WHERE question_id = ?
    AND parent_reply_id IS NULL
    SQL

    queries.map { |query| Reply.new(query) }
  end

  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @parent_reply_id = options["parent_reply_id"]
    @user_id = options["user_id"]
    @body = options["body"]
  end

end