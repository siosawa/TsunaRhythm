require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'layout links' do
    get root_path # rootパスに入る
    assert_template 'static_pages/home' # 最初のページはhomeのはずだ
    assert_select 'a[href=?]', root_path, count: 2 # rootパスへのリンクが2つあるはずだ
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
  end

  # test "the truth" do
  #   assert true
  # end
end
