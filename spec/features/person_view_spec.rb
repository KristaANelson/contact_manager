require 'rails_helper'

describe 'the person view', type: :feature do

  let(:person) {Person.create(first_name: 'John', last_name: 'Doe')}

  before(:each) do
    person.phone_numbers.create(number: '555-1234')
    person.phone_numbers.create(number: '555-9876')
    visit person_path(person)
  end

  it 'shows the phone numbers' do
    person.phone_numbers.each do |phone|
      expect(page).to have_content(phone.number)
    end
  end

  it 'has a link to add a new number' do
    expect(page).to have_link('Add phone number', href: new_phone_number_path)
  end
end
