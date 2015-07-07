Backbone = require 'backbone'
State = require '../branching_state/index.coffee'
map = require './map.coffee'
debug = require './debug.coffee'

module.exports = class InquiryQuestionnaireView extends Backbone.View
  className: 'inquiry-questionnaire'

  initialize: ({ @user, @artwork, prequalify }) ->
    @state = new State map
    @state.inject user: @user, state: @state
    @listenTo @state, 'next', @render

  render: ->
    debug @state

    @view?.remove()
    @view = @state.view user: @user, state: @state, artwork: @artwork
    @$el.html @view.render().$el

    this