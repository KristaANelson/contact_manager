require 'rails_helper'

describe 'the person view', type: :feature do

  let(:person) {Person.create(first_name: 'John', last_name: 'Doe')}

  describe 'phone numbers' do

    before(:each) do
      person.phone_numbers.create(number: '555-1234')
      person.phone_numbers.create(number: '555-9876')
      visit person_path(person)
    end

    it 'removes phone number from list after destroy' do
      first = person.phone_numbers.first
      expect(page).to have_content(first.number)
      within('#id_0') do
        page.click_link_or_button('delete')
      end
      expect(page).to_not have_content(first.number)
    end

    it 'shows the phone numbers' do
      person.phone_numbers.each do |phone|
        expect(page).to have_content(phone.number)
      end
    end

    it 'has a link to add a new number' do
      expect(page).to have_link('Add phone number', href: new_phone_number_path(person_id: person.id))
    end

    it 'add a new phone number' do
      page.click_link('Add phone number')
      page.fill_in('Number', with: '555-8888')
      page.click_button('Create Phone number')
      expect(current_path).to eq(person_path(person))
      expect(page).to have_content('555-8888')
    end

    it 'has links to edit phone numbers' do
      person.phone_numbers.each do |phone|
        expect(page).to have_link('edit', href:edit_phone_number_path(phone))
      end
    end

    it 'edits a phone number' do
      phone = person.phone_numbers.first
      old_number = phone.number

      first(:link, 'edit').click
      page.fill_in('Number', with: '555-9191')
      page.click_button('Update Phone number')
      expect(current_path).to eq(person_path(person))
      expect(page).to have_content('555-9191')
      expect(page).to_not have_content(old_number)
    end

    it 'has links to delete phone numbers' do
      person.phone_numbers.each do |phone|
        expect(page).to have_link('delete', href:phone_number_path(phone))
      end
    end
  end

  describe 'email addresses' do

    before(:each) do
      person.email_addresses.create(address: 'krista.nelson@gmail.com')
      person.email_addresses.create(address: 'work_email@work.com')
      visit person_path(person)
    end

    it 'looks for lis for each address' do
      expect(page).to have_selector('li', text: 'krista.nelson@gmail.com')
    end

    it 'has an email address link' do
      page.click_link('Add email address')
      page.fill_in('Address', with: 'rocko@gmail.com')
      page.click_button('Create Email address')
      expect(current_path).to eq(person_path(person))
      expect(page).to have_content('rocko@gmail.com')
    end

    it 'edits an email address' do
      email = person.email_addresses.first
      old_email = email.address

      first(:link, 'edit').click
      page.fill_in('Address', with: 'update@gmail.com')
      page.click_button('Update Email address')
      expect(current_path).to eq(person_path(person))
      expect(page).to have_content('update@gmail.com')
      expect(page).to_not have_content(old_email)
    end

    it 'destroys an email address' do
        person.email_addresses.each do |email|
        expect(page).to have_link('delete', href:email_address_path(email))
      end
    end

    it 'removes email from list after destroy' do
      first = person.email_addresses.first
      expect(page).to have_content(first.address)
      within('#email_id_0') do
        page.click_link_or_button('delete')
      end
      expect(page).to_not have_content(first.address)
    end

  end


end
