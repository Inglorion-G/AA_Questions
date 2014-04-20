['question_like', 'user', 'question', 'question_follower', 'reply'].each do |file|
  require_relative file
end

class QuestionLike
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
    SELECT *
    FROM question_likes
    WHERE id = :id
    SQL

    QuestionLike.new(query[0])
  end

  def self.likers_for_question_id(question_id)
    queries = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT u.id, u.fname, u.lname
    FROM
      question_likes q JOIN users u
    ON
      q.user_id = u.id
    WHERE
      question_id = ?
    SQL
    queries.map { |query| User.new(query) }
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT COUNT(user_id)
    FROM
      question_likes
    WHERE
      question_id = ?
    GROUP BY
      question_id
    SQL
    num_likes.first.values.first
  end

  def self.liked_questions_for_user_id(user_id)
    queries = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT q.id, q.title, q.body, q.author_id
    FROM
      question_likes l JOIN questions q
    ON
      l.user_id = q.author_id
    WHERE
      l.user_id = ?
    SQL
    queries.map { |query| Question.new(query) }
  end

  def self.most_liked_questions(n)
    queries = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT *
    FROM questions
    WHERE id IN (
      SELECT question_id
      FROM
        question_likes
      GROUP BY
        question_id
      ORDER BY
      -COUNT(user_id)
      LIMIT n
    )
    SQL
    queries.map { |query| Question.new(query) }
  end

  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end

end