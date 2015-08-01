path = require 'path'
{Emitter, Disposable, CompositeDisposable} = require 'atom'
{$, $$$, View} = require 'space-pen'
_ = require 'underscore-plus'
fs = require 'fs-plus'
ResizableImageView = require './resizable-image-view'

module.exports =
  class ImageResizeView extends View
    @content: ->
      @div class: 'atom-image-resize-container', tabindex: -1, =>
        @div outlet: "imageContainer"

    protocol: 'atom-image-resize:'
    regExpBase64EncodedImage: /data:image\/(jpeg|png);base64,(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?/gi

    constructor: ({@editorId, @filePath}) ->
      super
      @emitter = new Emitter
      @disposables = new CompositeDisposable
      @loaded = false

    attached: ->
      return if @isAttached
      @isAttached = true

      if @editorId?
        @resolveEditor(@editorId)
      else
        if atom.workspace?
          @subscribeToFilePath(@filePath)
        else
          @disposables.add atom.packages.onDidActivateInitialPackages =>
            @subscribeToFilePath(@filePath)

    #serialize: ->
    #  deserializer: 'ImageResizeView'
    #  filePath: @getPath()
    #  editorId: @editorId

    destroy: ->
      @disposables.dispose()

    onDidChangeTitle: (callback) ->
      @emitter.on 'did-change-title', callback

    onDidChangeModified: (callback) ->
      # No op to suppress deprecation warning
      new Disposable

    subscribeToFilePath: (filePath) ->
      @addResizableImageView filePath: filePath

    resolveEditor: (editorId) ->
      resolve = =>
        @editor = @editorForId(editorId)
        if @editor?
          @emitter.emit 'did-change-title' if @editor?
          @handleEvents()
          @addResizableImageViews()
        else
          # The editor this preview was created for has been closed so close
          # this preview since a preview cannot be rendered without an editor
          atom.workspace?.paneForItem(this)?.destroyItem(this)

      if atom.workspace?
        resolve()
      else
        @disposables.add atom.packages.onDidActivateInitialPackages(resolve)

    handleEvents: ->
      if @editor?
        @disposables.add @editor.onDidStopChanging => @addResizableImageViews()

    addResizableImageViews: () ->
      @resetImageViews()
      base64Images = @findBase64EncodedImage @editor.getText()
      base64Images.forEach (base64string, key) =>
        @addResizableImageView uri: base64string if base64string.length > 8

    resetImageViews: ()->
      @imageContainer.empty()

    findBase64EncodedImage: (text) ->
      text.match(@regExpBase64EncodedImage) || []

    addResizableImageView: ({uri, filePath}) ->
      if uri?
        @imageContainer.append new ResizableImageView uri: uri
      if filePath?
        @imageContainer.append new ResizableImageView filePath: filePath

    editorForId: (editorId) ->
      for editor in atom.workspace.getTextEditors()
        return editor if editor.id?.toString() is editorId.toString()
      null

    getTitle: ->
      if @file?
        "#{path.basename(@getPath())} Image Resize View"
      else if @editor?
        "#{@editor.getTitle()} Image Resize View"
      else
        "Image Resize View"

    getIconName: ->
      "ImageResizeView"

    getURI: ->
      if @file?
        "#{@protocol}//#{@getPath()}"
      else
        "#{@protocol}//editor/#{@editorId}"

    getPath: ->
      if @file?
        @file.getPath()
      else if @editor?
        @editor.getPath()
