select
  distinct
  FROM_UNIXTIME(au.senddate) as send_date, -- send date
  FROM_UNIXTIME(au.opendate) as open_date, -- first time user open the email
  au.open as open, -- number of times user open
  au.browser as browser, -- what browser user is using
  au.is_mobile as is_mobile, -- if user open using mobile
  au.mobile_os as mobile_os, -- mobile os this depends on is_mobile

  CHAR_LENGTH (am.subject) as subject_len, -- number of character of subject
  CHAR_LENGTH (am.body) as body_len, -- number of character of subject

  ac.click as url_click, -- number of time user click on link

  (
    select count(*)
    from onthi_vquiz_quizresult vqr
    where vqr.userid = users.id
  ) as quiz_attempt,

  (
    select count(*)
    from onthi_vquiz_quizresult vqr
    where vqr.userid = users.id
    and vqr.score > vqr.passed_score
  ) as successful_attempt,

  (
    select count(*)
    from onthi_vquiz_quizresult vqr
    where vqr.userid = users.id
    and vqr.score < vqr.passed_score
  ) as failed_attempt,

  TIMESTAMPDIFF(YEAR, asub.birthday, CURDATE()) AS age,
  obvp.province

from onthi_acymailing_userstats au
  inner join onthi_acymailing_mail am
    on au.mailid = am.mailid

  left join onthi_acymailing_urlclick ac
    on au.mailid = ac.mailid and au.subid = ac.subid

  left join onthi_acymailing_subscriber asub
    on asub.subid = au.subid

  left join onthi_users users
    on users.id = asub.userid

  left join onthi_bi_vn_province obvp
    on asub.province = obvp.id

where au.sent = 1;

select * from onthi_acymailing_userstats au;
select * from onthi_acymailing_mail am;
select * from onthi_acymailing_urlclick;