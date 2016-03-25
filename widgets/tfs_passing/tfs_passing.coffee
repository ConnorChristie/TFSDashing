class Dashing.TfsPassing extends Dashing.Widget

  ready: ->

  onData: (data) ->
    if data.all_passing
      $(@node).css('background-color', '#03A06E')
    else
      $(@node).css('background-color', '#a73737')

  @accessor 'updatedAtMessage', ->
    if updatedAt = @get('updatedAt')
      time = new Date(updatedAt * 1000).toLocaleTimeString('en-US')
      "Last updated at #{time}"