if Meteor.isClient
  Session.setDefault("page", 1)
  Session.setDefault("query", "chess")

  Template.flickr.events
    'keyup input': (e) ->
      Session.set("query", $(e.target).val())
    'click .next-page': () ->
      Session.set("page", Session.get("page") + 1)
    'click .prev-page': () ->
      Session.set("page", Session.get("page") - 1)

  Template.flickr.page = () -> Session.get "page"
  Template.flickr.query = () -> Session.get "query"
  Template.flickr.results = () -> Session.get "photos"
  Template.flickr.isLoading = () -> Session.get "isLoading"

  Template.flickr.getPhotoUrl = (photo) ->
      size = 'q'
      host = "farm#{photo.farm}.staticflickr.com"
      "http://#{host}/#{photo.server}/#{photo.id}_#{photo.secret}_#{size}.jpg"

  Template.flickr.rendered = () ->
    $('input').focus()
    
  Meteor.autorun () ->
    Session.set "isLoading", true
    flickrData = 
      method: 'flickr.photos.search'
      format: 'json'
      nojsoncallback: 1
      api_key: '07e0436936cf6efba41e7aa162049442'
      tags: Session.get("query")
      page: Session.get("page")
      per_page: 16
    $.get 'http://api.flickr.com/services/rest/', flickrData, (response) ->
      Session.set("photos", response.photos.photo)
      Session.set "isLoading", false