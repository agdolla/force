_ = require 'underscore'
_s = require 'underscore.string'
Backbone = require 'backbone'
AuthModalView = require '../auth_modal/view.coffee'
State = require './models/state.coffee'
template = -> require('./templates/index.jade') arguments...

module.exports = class AuctionArtworksView extends Backbone.View
  className: 'auction-artworks-container'
  events:
    'click .js-toggle-artworks-sort': 'setState'
    'click .js-bid-button': 'authOrPass'

  initialize: ({ @user }) ->
    @state = new State

    @listenTo @collection, 'reset add remove', @render
    @listenTo @state, 'change', @render
    @listenTo @user, 'change:registered_to_bid', @render if @user

  sorts: (artwork) ->
    { saleArtwork, artist } = artwork.related()

    default: saleArtwork.get('lot_number') or saleArtwork.get('position') or saleArtwork.id
    name_asc: artist.get('sortable_id')
    bids_desc: -(saleArtwork.get('bidder_positions_count'))
    bids_asc: saleArtwork.get('bidder_positions_count')
    amount_desc: -(saleArtwork.get('highest_bid_amount_cents') or saleArtwork.get('opening_bid_cents'))
    amount_asc: saleArtwork.get('highest_bid_amount_cents') or saleArtwork.get('opening_bid_cents')

  artworks: ->
    @collection.sortBy (artwork) =>
      @sorts(artwork)[@state.get('sort')]

  setState: (e) ->
    e.preventDefault()

    @state.set $(e.currentTarget).data()

  authOrPass: (e) ->
    return if @user?.isLoggedIn()

    e.preventDefault()
    new AuthModalView
      width: '500px'
      mode: 'register'
      copy: 'Sign up to bid'
      redirectTo: $(e.currentTarget).attr('href')

  displayBlurbs: ->
    _.any _.map(@collection.pluck('blurb'), _.negate(_.isEmpty))

  maxBlurbHeight: (displayBlurbs, lineHeight = 22, columnWidth = 50) ->
    return unless displayBlurbs

    Math.ceil(_.max(_.map @collection.pluck('blurb'), (blurb) ->
      ((_s.stripTags(blurb).length / columnWidth) * lineHeight) + lineHeight
    )) + 'px'

  render: ->
    @$el.html template
      state: @state
      user: @user
      auction: @model
      artworks: @artworks()
      displayBlurbs: displayBlurbs = @displayBlurbs()
      maxBlurbHeight: @maxBlurbHeight(displayBlurbs)
    this