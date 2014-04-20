['question_like', 'user', 'question', 'question_follower', 'reply'].each do |file|
  require_relative file
end

class QuestionLike

  def self.likers_for_question_id(question_id)
    user_queries = QuestionsDatabase.execute(<<-SQL, question_id: question_id)
      SELECT 
        u.*
      FROM
        question_likes q 
      JOIN 
        users u
      ON
        q.user_id = u.id
      WHERE
        question_id = :question_id
    SQL
    user_queries.map { |query| User.new(query) }
  end

  def self.num_likes_for_question_id(question_id)
    QuestionsDatabase.get_first_value(<<-SQL, question_id: question_id)
      SELECT 
        COUNT(*) AS likes
      FROM
        questions
      JOIN
        question_likes
      ON 
        questions.id = question_likes.question_id
      WHERE
        question_id = :question_id
      GROUP BY
        question_id
    SQL
  end

  def self.liked_questions_for_user_id(user_id)
    question_queries = QuestionsDatabase.execute(<<-SQL, user_id: user_id)
      SELECT 
        questions.*
      FROM
        question_likes
      JOIN 
        questions
      ON
        question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = :user_id
    SQL
    
    question_queries.map { |query| Question.new(query) }
  end

  def self.most_liked_questions(n)
    question_queries = QuestionsDatabase.execute(<<-SQL, limit: n)
      SELECT 
         *
      FROM 
        questions
      WHERE 
        id IN (
        SELECT 
          question_id
        FROM
          question_likes
        GROUP BY
          question_id
        ORDER BY
          -COUNT(user_id)
        LIMIT 
          :limit
        )
    SQL
    
    question_queries.map { |query| Question.new(query) }
  end

end