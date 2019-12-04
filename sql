

WITH QuestionScores AS
(
  SELECT
    Users.Id AS [User Link],
    SUM(Questions.Score) AS Score
  FROM Posts as Questions 
    INNER JOIN Users
    ON Questions.OwnerUserId = Users.Id
    
    INNER JOIN PostTags 
    ON PostTags.PostId = Questions.Id
    
    INNER JOIN Tags
    on Tags.Id = PostTags.TagId
  WHERE
    LOWER(Location) LIKE LOWER('%##location##%')
    and Tags.Tagname='##tagname##'
  GROUP BY
    Users.Id
),

AnswerScores AS
(
  SELECT
    Users.Id AS [User Link],
    SUM(Answers.Score) AS Score
  FROM Posts AS Answers 
    INNER JOIN Posts AS ParentQuestions 
    ON ParentQuestions.Id = Answers.ParentId
    
    INNER JOIN Users AS Users
    ON Answers.OwnerUserId = Users.Id
    
    INNER JOIN PostTags 
    ON PostTags.PostId = Answers.ParentId
    
    INNER JOIN Tags
    ON Tags.Id = PostTags.TagId
  WHERE
    LOWER(Location) LIKE LOWER('%##location##%')
    and Tags.Tagname='##tagname##'
  GROUP BY
    Users.Id
)

SELECT 
  TOP 100
  ISNULL(QuestionScores.[User Link], AnswerScores.[User Link]) as [User Link],
  ISNULL(QuestionScores.Score, 0) as [Question Score],
  ISNULL(AnswerScores.Score, 0) as [Answer Score],
  ISNULL(QuestionScores.Score, 0) + ISNULL(AnswerScores.Score, 0) as [Total Score]
FROM
  QuestionScores
FULL JOIN AnswerScores 
  ON QuestionScores.[User Link] = AnswerScores.[User Link]
ORDER BY
  [Total Score] DESC;
