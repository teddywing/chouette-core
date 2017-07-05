describe TableBuilderHelper::CustomLinks do
  describe "#actions_after_policy_check" do
    it "includes :show" do
      referential = build_stubbed(:referential)
      user_context = UserContext.new(
        build_stubbed(
          :user,
          organisation: referential.organisation,
        ),
        referential: referential
      )

      stub_policy_scope(referential)
      expect(
        TableBuilderHelper::CustomLinks.new(
          referential,
          user_context,
          [:show]
        ).authorized_actions
      ).to eq([:show])
    end
  end
end
