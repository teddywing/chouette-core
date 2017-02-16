(function($) {

  /**
   * polyfill for html5 form attr
   */
  var SAMPLE_FORM_NAME, sampleElementFound, sampleForm, sampleFormAndHiddenInput;
  SAMPLE_FORM_NAME = 'html-5-polyfill-test';
  sampleForm = $('<form id=\'' + SAMPLE_FORM_NAME + '\'/>');
  sampleFormAndHiddenInput = sampleForm.add($('<input type=\'hidden\' form=\'' + SAMPLE_FORM_NAME + '\'/>'));
  sampleFormAndHiddenInput.prependTo('body');
  sampleElementFound = sampleForm[0].elements[0];
  sampleFormAndHiddenInput.remove();
  if (sampleElementFound) {
    return;
  }

  /**
   * Append a field to a form
  #
   */
  $.fn.appendField = function(data) {
    var $form;
    if (!this.is('form')) {
      return;
    }
    if (!$.isArray(data) && data.name && data.value) {
      data = [data];
    }
    $form = this;
    $.each(data, function(i, item) {
      $('<input/>').attr('type', 'hidden').attr('name', item.name).val(item.value).appendTo($form);
    });
    return $form;
  };

  /**
   * Find all input fields with form attribute point to jQuery object
   *
   */
  $('form[id]').submit(function(e) {
    var data;
    data = $('[form=' + this.id + ']').serializeArray();
    $(this).appendField(data);
  }).each(function() {
    var $fields, form;
    form = this;
    $fields = $('[form=' + this.id + ']');
    $fields.filter('button, input').filter('[type=reset],[type=submit]').click(function() {
      var type;
      type = this.type.toLowerCase();
      if (type === 'reset') {
        form.reset();
        $fields.each(function() {
          this.value = this.defaultValue;
          this.checked = this.defaultChecked;
        }).filter('select').each(function() {
          $(this).find('option').each(function() {
            this.selected = this.defaultSelected;
          });
        });
      } else if (type.match(/^submit|image$/i)) {
        $(form).appendField({
          name: this.name,
          value: this.value
        }).submit();
      }
    });
  });
})(jQuery);
