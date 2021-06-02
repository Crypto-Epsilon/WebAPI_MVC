# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test AddSwiperToPet service' do
  before do
    wipe_database

    DATA[:accounts].each do |account_data|
      Pets_Tinder::Account.create(account_data)
    end
  end

  it 'HAPPY: should authenticate valid account credentials' do
    credentials = DATA[:accounts].first
    account = Pets_Tinder::AuthenticateAccount.call(
      username: credentials['username'], password: credentials['password']
    )
    _(account).wont_be_nil
  end

  it 'SAD: will not authenticate with invalid password' do
    credentials = DATA[:accounts].first
    _(proc {
        Pets_Tinder::AuthenticateAccount.call(
        username: credentials['username'], password: 'malword'
      )
    }).must_raise Pets_Tinder::AuthenticateAccount::UnauthorizedError
  end

  it 'BAD: will not authenticate with invalid credentials' do
    _(proc {
        Pets_Tinder::AuthenticateAccount.call(
        username: 'maluser', password: 'malword'
      )
    }).must_raise Credence::AuthenticateAccount::UnauthorizedError
  end
end