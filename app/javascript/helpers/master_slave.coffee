class MasterSlave
  constructor: (selector)->
    $(selector).find('[data-master]').each (i, slave)->
      $slave = $(slave)
      master = $($slave.data().master)
      console.log $slave.data().master
      console.log master
      toggle = ->
        val = master.filter(":checked").val() if master.filter("[type=radio]").length > 0
        val ||= master.val()
        selected = val == $slave.data().value
        $slave.toggle selected
        $slave.find("input, select").attr "disabled", !selected
      master.change toggle
      toggle()
      # $slave.toggle master.val() == $slave.data().value

export default MasterSlave
