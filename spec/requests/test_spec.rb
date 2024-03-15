#最初のRSpecテスト
require'rails_helper'
RSpec.describe 'RSpecのテスト' do
  it 'trueはいつもtrueか' do
    expect(true).to eq(true)
  end
end

