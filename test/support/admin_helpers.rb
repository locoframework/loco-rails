# frozen_string_literal: true

module AdminHelpers
  def sign_in
    visit '/admin/sessions/new'
    fill_in 'Email', with: 'zbigniew.humeniuk@motteq.com'
    fill_in 'Password', with: 'ubersecure!'
    click_button 'Sign In'
  end

  def update_article(article)
    article.title = 'AGtTRA'
    article.text = 'TESTING_SUPPORT...' * 6
    article.save!
    emit article, :updated, for: [:all]
    perform_enqueued_jobs
  end

  def publish_article(article)
    article.publish
    emit article, :published, data: { id: article.id }
    perform_enqueued_jobs
  end
end
