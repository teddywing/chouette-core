class PublicVersion < PaperTrail::Version
  # custom behaviour, e.g:
  self.table_name = :'public.versions'
end
