// Need to toggle radio button
//

$( () => {
  const thereCanBeOnlyOne_OrNone = function(){
    // 'checked' is already the new state
    if (!$(this).prop('checked')) {
      return true;
    }
    $('.checkbox-wrapper').find('input[type="checkbox"]').prop('checked', false);
    $(this).prop('checked', true);
  };
  $('.checkbox-wrapper').find('input[type="checkbox"]').on('click', thereCanBeOnlyOne_OrNone)
  }
)
