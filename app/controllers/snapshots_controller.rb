class SnapshotsController < ApplicationController
  if Rails.env.development? || Rails.env.test?
    layout :which_layout
    def show
      tpl = params[:snap]
      tpl = tpl.gsub Rails.root.to_s, ''
      render file: tpl
    end

    def which_layout
      "snapshots/#{params[:layout] || "default"}"
    end
  end
end
