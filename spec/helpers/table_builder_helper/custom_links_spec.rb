require 'spec_helper'

describe TableBuilderHelper::CustomLinks do
  describe "#actions_after_policy_check" do
    it "includes :show" do
      referential = build_stubbed(:referential)
      user_context = UserContext.new(
        build_stubbed(
          :user,
          organisation: referential.organisation,
          permissions: [
            'boiv:read-offer'
          ]
        ),
        referential: referential
      )

      expect(
        TableBuilderHelper::CustomLinks.new(
          referential,
          user_context,
          [:show]
        ).actions_after_policy_check
      ).to eq([:show])
    end
  end
end
