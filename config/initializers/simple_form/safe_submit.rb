::SimpleForm::FormBuilder.class_eval do
  def button_with_safe_submit(type, *args, &block)
    options = args.extract_options!.dup
    if type == :submit
      options[:data] ||= {}
      options[:data][:disable_with] ||= I18n.t('actions.wait_for_submission')
    end
    args << options
    button_without_safe_submit type, *args, &block
  end
  alias_method_chain :button, :safe_submit
end
