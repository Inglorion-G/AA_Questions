require_relative 'question'
require_relative 'questions_db'
require_relative 'user'

class QuestionFollower

  def self.followers_for_question_id(question_id)
    user_queries = QuestionsDatabase.execute(<<-SQL, question_id: question_id)
      SELECT 
        u.*
      FROM
        users u 
      JOIN 
        question_followers q
      ON
        u.id = q.follower_id
      WHERE
        q.question_id = :question_id
    SQL
    
    user_queries.map { |query| User.new(query) }
  end

  def self.followed_questions_for_user_id(user_id)
    question_queries = QuestionsDatabase.execute(<<-SQL, user_id: user_id)
      SELECT 
        q.*
      FROM
        questions q 
      JOIN 
        question_followers f
      ON
        q.id = f.question_id
      WHERE
        f.follower_id = :user_id
    SQL
    
    question_queries.map { |query| Question.new(query) }
  end

  def self.most_followed_questions(n)
    question_queries = QuestionsDatabase.execute(<<-SQL, limit: n)
    SELECT 
      *
    FROM 
      questions
    WHERE id IN (
      SELECT 
        question_id
      FROM
        question_followers
      GROUP BY
        question_id
      ORDER BY
        -COUNT(follower_id)
      LIMIT 
        :limit
    )
    SQL
    question_queries.map { |query| Question.new(query) }
  end

end