module AF83
  module SimpleForm
    module SafeSubmit
      def self.decorate_simple_form
        ::SimpleForm::FormBuilder.class_eval do
          def button(type, *args, &block)
            options = args.extract_options!.dup
            options[:class] = [::SimpleForm.button_class, options[:class]].compact
            if type == :submit
              options[:data] ||= {}
              options[:data][:disable_with] ||= I18n.t('actions.wait_for_submission')
            end
            args << options
            if respond_to?(:"#{type}_button")
              send(:"#{type}_button", *args, &block)
            else
              send(type, *args, &block)
            end
          end
        end
      end
    end
  end
end
