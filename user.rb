['question_like', 'user', 'question', 'question_follower', 'reply'].each do |file|
  require_relative file
end


class TableSaver
  def save

    p instance_values = self.instance_variables.map do |instance_variable|
      instance_variable.to_s
    end
    p questions = ("?"*instance_values.length).split(//).join(', ')

    p table_name = self.class.to_s.downcase.pluralize

    p column_names = instance_values.dup.map do |instance_value|
      instance_value.to_s[1,-1]
    end

    # if @id.nil?
    #   QuestionsDatabase.instance.execute(<<-SQL, #{*instance_values})
    #   INSERT INTO
    #   #{table_name}(#{*column_names})
    #   VALUES
    #   (#{questions})
    #   SQL
    # else
    #   QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
    #   UPDATE
    #     users
    #   SET
    #     fname=?, lname=?
    #   WHERE
    #     id = ?
    #   SQL
    # end
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
end



class User < TableSaver

  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM users
    WHERE id = ?
    SQL
    User.new(query[0])
  end

  def self.find_by_name(fname, lname)
    query = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT *
    FROM users
    WHERE fname = ?
    AND lname = ?
    SQL

    User.new(query[0])
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def initialize(options = {})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

  def average_karma
    karma = QuestionsDatabase.instance.get_first_row(<<-SQL, @id)
    SELECT COUNT(l.id) / CAST(COUNT(DISTINCT(q.id)) AS FLOAT)
    FROM
      questions q
    LEFT OUTER JOIN
      question_likes l
    ON
      q.id = l.question_id
    WHERE
      q.author_id = ?
    SQL
    karma.values[0]
  end

end
