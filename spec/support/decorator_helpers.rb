module Support
  def self.get_ivar(ivar_name)
    -> object do
      object.instance_variable_get("@#{ivar_name}")
    end
  end

  module DecoratorHelpers
    def self.included(into)
      into.instance_eval do
        subject{ object.decorate }
        let( :policy ){ ::Pundit.policy(user_context, object) }
        let( :user_context ){ UserContext.new(user, referential: referential) }

        before do
          allow_any_instance_of(Draper::HelperProxy).to receive(:policy).and_return policy
        end
      end
    end

    def expect_action_link_hrefs
      expect( subject.action_links.select(&Link.method(:===)).map(&:href) )
    end
    def expect_action_link_elements
      expect( subject.action_links.select(&HTMLElement.method(:===)).map(&Support.get_ivar(:content)) )
    end
  end
end

RSpec.configure do | c |
  c.include Support::DecoratorHelpers, type: :decorator
end
