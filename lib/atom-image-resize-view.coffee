path = require 'path'
{Emitter, Disposable, CompositeDisposable} = require 'atom'
{$, $$$, View} = require 'space-pen'
_ = require 'underscore-plus'
fs = require 'fs-plus'
ResizableImageView = require './resizable-image-view'

module.exports =
  class ImageResizeView extends View
    @content: ->
      @div class: 'atom-image-resize-container native-key-bindings', tabindex: -1, =>
        @div outlet: "imageContainer"

    protocol: 'atom-image-resize:'

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
          @addResizableImageViews()
        else
          # The editor this preview was created for has been closed so close
          # this preview since a preview cannot be rendered without an editor
          atom.workspace?.paneForItem(this)?.destroyItem(this)

      if atom.workspace?
        resolve()
      else
        @disposables.add atom.packages.onDidActivateInitialPackages(resolve)

    addResizableImageViews: () ->
      words = @editor.getText().split(/\s+/)
      words.forEach (base64string, key) =>
        @addResizableImageView uri: base64string if base64string.length > 8

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

    showError: (result) ->
      failureMessage = result?.message

      @html $$$ ->
        @h2 'Previewing Image Failed'
        @h3 failureMessage if failureMessage?

    showLoading: ->
      @loading = true
      @html $$$ ->
        @div class: 'markdown-spinner', 'Loading Markdown\u2026'
