path = require 'path'
ResizableImageView = require '../lib/resizable-image-view.coffee'
fixtures = require './fixtures/base64images.coffee'

describe "ResizableImageView", ->
  describe "when create new object", ->
    it "should be has default unit property", ->
      obj = new ResizableImageView uri: fixtures.base64jpeg
      expect(obj.unit).toEqual "pixel"

    describe "when provide base64 encoded png or jpeg image", ->
      it "should be has same extension property", ->
        obj = null
        runs ->
          obj = new ResizableImageView uri: fixtures.base64jpeg
          obj.trigger "attached"
        waitsFor (()-> obj.loaded), "loading image", 200
        runs ->
          expect(obj.extension).toEqual "jpeg"

      it "should be has same extension property", ->
        obj = null
        runs ->
          obj = new ResizableImageView uri: fixtures.base64png
          obj.trigger "attached"
        waitsFor (()-> obj.loaded), "loading image", 200
        runs ->
          expect(obj.extension).toEqual "png"

    describe "when provide base64 encoded gif image", ->
        obj = null
        runs ->
          obj = new ResizableImageView uri: fixtures.base64gif
          obj.trigger "attached"
        waitsFor (()-> obj.loaded), "loading image", 200
        runs ->
          expect(obj.extension).toEqual "png"

    describe "when provide filePath", ->
      it "should be has same extension property", ->
        obj = null
        runs ->
          obj = new ResizableImageView filePath: path.join atom.project.getPaths()[0], "/images/blue.jpg"
          obj.trigger "attached"
        waitsFor (()-> obj.loaded), "loading image", 200
        runs ->
          expect(obj.extension).toEqual "jpeg"

      it "should be has same extension property", ->
        obj = null
        runs ->
          obj = new ResizableImageView filePath: path.join atom.project.getPaths()[0], "/images/blue.jpeg"
          obj.trigger "attached"
        waitsFor (()-> obj.loaded), "loading image", 200
        runs ->
          expect(obj.extension).toEqual "jpeg"

      it "should be has same extension property", ->
        obj = null
        runs ->
          obj = new ResizableImageView filePath: path.join atom.project.getPaths()[0], "/images/blue.png"
          obj.trigger "attached"
        waitsFor (()-> obj.loaded), "loading image", 200
        runs ->
          expect(obj.extension).toEqual "png"

      it "should be has same extension property", ->
        obj = null
        runs ->
          obj = new ResizableImageView filePath: path.join atom.project.getPaths()[0], "/images/blue.gif"
          obj.trigger "attached"
        waitsFor (()-> obj.loaded), "loading image", 200
        runs ->
          expect(obj.extension).toEqual "png"

  describe "has two input fields", ->
    it "should be has value", ->
      obj = null
      runs ->
        obj = new ResizableImageView uri: fixtures.base64jpeg
        obj.trigger "attached"
      waitsFor (()-> obj.loaded), "loading image", 200
      runs ->
        expect(obj.inputWidth.getText()).toEqual("10")
        expect(obj.inputHeight.getText()).toEqual("10")
