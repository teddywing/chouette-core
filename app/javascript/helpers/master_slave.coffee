class MasterSlave
  constructor: (selector)->
    $(selector).find('[data-master]').each (i, slave)->
      $slave = $(slave)
      master = $($slave.data().master)
      $slave.find("input:disabled, select:disabled").attr "data-slave-force-disabled", "true"
      toggle = ->
        val = master.filter(":checked").val() if master.filter("[type=radio]").length > 0
        val ||= master.val()
        selected = val == $slave.data().value
        $slave.toggle selected
        $slave.find("input, select").filter(":not([data-slave-force-disabled])").attr "disabled", !selected
      master.change toggle
      toggle()

export default MasterSlave
