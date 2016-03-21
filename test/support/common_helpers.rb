module CommonHelpers
  def delete_cookies
    browser = Capybara.current_session.driver.browser
    if browser.respond_to?(:clear_cookies)
      # Rack::MockSession
      browser.clear_cookies
    elsif browser.respond_to?(:manage) and browser.manage.respond_to?(:delete_all_cookies)
      # Selenium::WebDriver
      browser.manage.delete_all_cookies
    else
      raise "Don't know how to clear cookies. Weird driver?"
    end
  end

  def update_value_attr_for sel
    page.execute_script "$('#{sel}').attr('value', $('#{sel}').val());"
  end

  def create_comment_for_article name, opts = {}
    author = opts[:author] || 'Ryan'
    text = opts[:text] || 'Some nice thoughts dude'
    comment = articles(name).comments.create! author: author, text: text
    emit comment, :created, data: {article_id: comment.article_id}
    comment
  end

  def destroy_comment comment
    comment.destroy
    emit comment, :destroyed, data: {article_id: comment.article_id}
  end

  def update_comment comment
    comment.text = "#{comment.text} (edited)"
    comment.save!
    emit comment, :updated, data: {article_id: comment.article_id}
  end
end