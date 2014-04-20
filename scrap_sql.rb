SELECT question_id,
COUNT(user_id)
 FROM
question_likes
GROUP By
question_id