['question_like', 'user', 'question', 'question_follower', 'reply'].each do |file|
  require_relative file
end

class QuestionFollower
  attr_accessor :id, :question_id, :follower_id

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
    SELECT *
    FROM question_followers
    WHERE id = :id
    SQL

    QuestionFollower.new(query[0])
  end

  def self.followers_for_question_id(question_id)
    queries = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT u.id, u.fname, u.lname
    FROM
      users u JOIN question_followers q
    ON
      u.id = q.follower_id
    WHERE
      q.question_id = ?
    SQL
    queries.map { |query| User.new(query) }
  end

  def self.followed_questions_for_user_id(user_id)
    queries = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT q.id, q.title, q.body, q.author_id
    FROM
      questions q JOIN question_followers f
    ON
      q.id = f.question_id
    WHERE
      f.follower_id = ?
    SQL
    queries.map { |query| Question.new(query) }
  end

  def self.most_followed_questions(n)
    queries = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT *
    FROM questions
    WHERE id IN (
      SELECT question_id
      FROM
        question_followers
      GROUP BY
        question_id
      ORDER BY
      -COUNT(follower_id)
      LIMIT ?
    )
    SQL
    queries.map { |query| Question.new(query) }
  end

  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @follower_id = options["follower_id"]
  end

end