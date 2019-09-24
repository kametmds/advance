class FeedMailer < ApplicationMailer
  def feed_mail(feed)
    @feed = feed
    mail to: "yuki8118tmds@gmail.com", subject: "投稿確認メール"
  end
end
