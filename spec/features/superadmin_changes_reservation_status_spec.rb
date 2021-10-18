require 'spec_helper'

feature 'SuperAdmin changes reservation status', js: true do
  before do
    @user = create :user
    @admin = create :user, :super_admin
    @lab = create :lab, :with_equipment
    @lab_space = LabSpace.first
    @equipment = Equipment.first
    create :available_hour, equipment: @equipment, day_of_week: Date.today.wday

    sign_in_as @admin
  end

  context 'that they own' do
    before do
      create :reservation, :confirmed, user: @admin, equipment: @equipment
      visit lab_lab_space_equipment_path(@lab, @lab_space, @equipment)
      find('.fc-timegrid-event-harness').click
    end

    after do
      expect(emails.count).to eq(1)
      expect(last_email.to).to eq [@admin.email]
    end

    scenario 'to cancelled' do
      accept_alert do
        click_button 'Cancelar'
      end

      expect(page).to have_selector('#detailModal', visible: false)
      expect(page).not_to have_selector('.fc-timegrid-event-harness')
      expect(first_reservation.status).to eq('cancelled')
      expect(last_email.subject).to eq 'Tu reservación ha sido Cancelada'
    end
  end

  context 'that another user owns' do
    before do
      create :reservation, :confirmed, user: @user, equipment: @equipment
      visit lab_lab_space_equipment_path(@lab, @lab_space, @equipment)
      find('.fc-timegrid-event-harness').click
    end

    after do
      expect(emails.count).to eq(1)
      expect(last_email.to).to eq [@user.email]
    end

    scenario 'to cancelled' do
      accept_alert do
        click_button 'Cancelar'
      end

      expect(page).to have_selector('#detailModal', visible: false)
      expect(page).not_to have_selector('.fc-timegrid-event-harness')
      expect(first_reservation.status).to eq('cancelled')
      expect(last_email.subject).to eq 'Tu reservación ha sido Cancelada'
    end
  end
end
