class FeedMailer < ApplicationMailer
  def feed_mail(feed)
    @feed = feed
    mail to: @feed.user.email, subject: "投稿確認メール"
  end
end
