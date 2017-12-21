describe "PurchaseWindows", type: :feature do
  login_user

  describe "#index" do
    with_permissions('purchase_windows.create') do
      it "allows users to create new purchase windows" do
        name = 'Test purchase window create'

        visit(referential_purchase_windows_path(first_referential.id))

        click_link(I18n.t('purchase_windows.actions.new'))

        fill_in('purchase_window[name]', with: name)
        select('#DD2DAA', from: 'purchase_window[color]')

        click_link(I18n.t('simple_form.labels.purchase_window.add_a_date_range'))
        click_button(I18n.t('actions.submit'))

        expect(page).to have_content(name)
      end
    end
  end
end
