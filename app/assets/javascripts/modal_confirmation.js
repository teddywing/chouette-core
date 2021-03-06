$(document).ready(() => {
  $.rails.allowAction = (link) => {
    let message = link.data('confirm')
    if (!message) return true
    showConfirmModal(link)
    return false
  }

  let showConfirmModal = (link) => {
    let message = link.data('confirm')
    let html = `<div class="modal fade" id="confirmationDialog" tabindex="1" role="dialog">
        <div class="modal-container">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h4 class="modal-title"> ${I18n.t('warning')} </h4>
              </div>
              <div class="modal-body">
                <p>${message}</p>
              </div>
              <div class="modal-footer">
                <a data-dismiss="modal" class="btn">${I18n.t('cancel')}</a>
                <a data-dismiss="modal" class="btn btn-primary" data-method=${link.data('method')} href=${link.attr('href')}>${I18n.t('ok')}</a>
              </div>
            </div>
          </div>
        </div>
      </div> `
    $(html).modal()
  }
})