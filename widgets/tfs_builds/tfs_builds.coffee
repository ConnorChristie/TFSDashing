class Dashing.TfsBuilds extends Dashing.Widget

  ready: ->


  onData: (data) ->


  @accessor 'updatedAtMessage', ->
    if updatedAt = @get('updatedAt')
      time = new Date(updatedAt * 1000).toLocaleTimeString('en-US')
      "Last updated at #{time}"