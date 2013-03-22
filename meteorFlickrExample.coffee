if Meteor.isClient
  Session.setDefault("page", 1)
  Session.setDefault("query", "chess")

  Template.flickrSearch.events
    'keyup input': (e) ->
      console.log "changed"
      Session.set("query", $(e.target).val())

  Template.flickrResults.photos = () ->
    console.log "results photos", Session.get "photos"
    Session.get "photos"

  Template.flickrResults.helpers 
    getPhotoUrl: (photo) ->
      size = 'q'
      host = "farm#{photo.farm}.staticflickr.com"
      "http://#{host}/#{photo.server}/#{photo.id}_#{photo.secret}_#{size}.jpg"

  Meteor.startup () ->
    flickrData = 
      method: 'flickr.photos.search'
      format: 'json'
      nojsoncallback: 1
      api_key: '07e0436936cf6efba41e7aa162049442'
      tags: Session.get("query")
      page: Session.get("page")
      per_page: 16
    $.get 'http://api.flickr.com/services/rest/', flickrData, (response) ->
      console.log "response", response
      Session.set("photos", response.photos.photo)

