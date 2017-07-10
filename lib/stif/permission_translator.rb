module Stif
  module PermissionTranslator extend self
    def translate(sso_extra_permissions)
      %w{sessions:create}
    end
  end
end
