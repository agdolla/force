{ INQUIRY } = require('sharify').data
InquiryOutcome = require '../../../../models/inquiry_outcome.coffee'
Form = require '../../../../components/form/index.coffee'
FlashMessage = require '../../../../components/flash/index.coffee'

module.exports = ->
  inquiry = new InquiryOutcome INQUIRY
  form = new Form model: inquiry, $form: $('form')
  $('button').click (e) ->
    e.preventDefault()
    form.submit e,
      success: ->
        new FlashMessage message: 'Thank you for your feedback.', autoclose: false, href: '/' #redirect to homepage
      
      error: (model, response) =>
        new FlashMessage message: form.errors.parse response