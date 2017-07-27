require 'rails_helper'

RSpec.describe CalendarObserver, type: :observer do
  let(:calendar) { create(:calendar, shared: true) }
  let(:user)     { create(:user, organisation: create(:organisation)) }

  context 'after_update' do
    it 'should observe calendar updates' do
      expect(CalendarObserver.instance).to receive(:after_update).with calendar
      calendar.update_attribute(:name, 'edited_name')
    end

    it 'should schedule mailer on calendar update' do
      calendar.name = 'edited_name'
      expect(MailerJob).to receive(:perform_later).with 'CalendarMailer', 'updated', [calendar.id, user.id]
      calendar.save
    end

    it 'should not schedule mailer for none shared calendar on update' do
      calendar = create(:calendar, shared: false)
      calendar.name = 'edited_name'
      expect(MailerJob).to_not receive(:perform_later).with 'CalendarMailer', 'updated', [calendar.id, user.id]
      calendar.save
    end
  end

  context 'after_create' do
    it 'should observe calendar create' do
      expect(CalendarObserver.instance).to receive(:after_create)
      build(:calendar).save
    end

    it 'should schedule mailer on calendar create' do
      expect(MailerJob).to receive(:perform_later).with 'CalendarMailer', 'created', [anything, user.id]
      build(:calendar, shared: true).save
    end

    it 'should not schedule mailer for none shared calendar on create' do
      expect(MailerJob).to_not receive(:perform_later).with 'CalendarMailer', 'created', [anything, user.id]
      build(:calendar, shared: false).save
    end
  end
end
