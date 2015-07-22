url = require 'url'
ImageResizeView = require './atom-image-resize-view'
{CompositeDisposable} = require 'atom'

module.exports = ImageResizeMain =
  subscriptions: null
  protocol: 'atom-image-resize:'

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-image-resize:toggle': => @toggle()

    atom.workspace.addOpener (uriToOpen) =>
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
        console.log error
        return
      return unless protocol is @protocol

      try
        pathname = decodeURI(pathname) if pathname
      catch error
        return

      if host is 'previewer'
        new ImageResizeView(editorId: pathname.substring(1))
      else
        new ImageResizeView(filePath: pathname.slice(0, pathname.lastIndexOf('.')))

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->
    myPackageViewState: @imageResizeView.serialize()

  toggle: ->
    uri = undefined
    if editor = atom.workspace.getActiveTextEditor()
      uri = "#{@protocol}//previewer/#{editor.id}" # Preview base64 encoded image
    else if editor = atom.workspace.getActivePaneItem()
      uri = "#{@protocol}//#{editor.getPath()}._" if editor.constructor.name is 'ImageEditor' # Preview local image file
    return unless uri

    # hidden pane if preveiw was shown
    previewPane = atom.workspace.paneForURI(uri)
    if previewPane
      previewPane.destroyItem(previewPane.itemForURI(uri))
      return

    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true).done (previewView) ->
      if previewView instanceof ImageResizeView
        previousActivePane.activate()
