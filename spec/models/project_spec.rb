require 'rails_helper'

RSpec.describe Project, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to(:author) }
  end

  describe 'columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:author_id).of_type(:integer) }
    it { is_expected.to have_db_column(:status).of_type(:string) }
    it { is_expected.to have_db_column(:api_host).of_type(:string) }
    it { is_expected.to have_db_column(:properties).of_type(:json) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  end
end
