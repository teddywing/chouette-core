object @time_table

node(:name) { I18n.l(@date, format: '%B') }
node(:days) {|tt| tt.month_inspect(@date) }
