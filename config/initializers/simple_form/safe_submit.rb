AF83::SimpleForm::SafeSubmit.decorate_simple_form

if Rails.env.development?
  ActionDispatch::Reloader.to_prepare do
    AF83::SimpleForm::SafeSubmit.decorate_simple_form
  end
end
