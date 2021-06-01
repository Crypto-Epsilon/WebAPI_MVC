# frozen_string_literal: true

describe 'Test Password Digestion' do
  it 'SECURITY: create password digests safely, hiding raw password' do
    password = 'thesecretlifeofwaltermitty'
    digest = Pets_Tinder::Password.digest(password)

    _(digest.to_s.match?(password)).must_equal false
  end

  it 'SECURITY: successfully checks correct password from stored digest' do
    password = 'thesecretlifeofwaltermitty'
    digest_s = Pets_Tinder::Password.digest(password).to_s

    digest = Pets_Tinder::Password.from_digest(digest_s)
    _(digest.correct?(password)).must_equal true
  end

  it 'SECURITY: successfully detects incorrect password from stored digest' do
    password1 = 'thesecretlifeofwaltermitty'
    password2 = 'beautifulthingsdontaskforattention'
    digest_s1 = Pets_Tinder::Password.digest(password1).to_s

    digest1 = Pets_Tinder::Password.from_digest(digest_s1)
    _(digest1.correct?(password2)).must_equal false
  end
end
