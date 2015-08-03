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

  describe "input fields", ->
    describe "set/getInputWidth set number value", ->
      it "should be get same number", ->
        obj = new ResizableImageView url: null
        width = 10000000
        obj.setInputWidth width
        expect(obj.getInputWidth()).toEqual(width)

    describe "set/getInputHeight set number value", ->
      it "should be get same number", ->
        obj = new ResizableImageView url: null
        height = 20000000
        obj.setInputHeight height
        expect(obj.getInputHeight()).toEqual(height)

    describe "set/getInputWidth set string value", ->
      it "should be get as number", ->
        obj = new ResizableImageView url: null
        width = '10000000'
        obj.setInputWidth width
        expect(obj.getInputWidth()).toEqual(Number width)

    describe "set/getInputHeight set string value", ->
      it "should be get as number", ->
        obj = new ResizableImageView url: null
        height = '20000000'
        obj.setInputHeight height
        expect(obj.getInputHeight()).toEqual(Number height)

    describe "set/getInputWidth set invalid string value", ->
      it "should be get old value", ->
        obj = new ResizableImageView url: null
        width = 10000000
        obj.setInputWidth width
        expect(obj.getInputWidth()).toEqual(width)
        obj.setInputWidth "invalid string"
        expect(obj.getInputWidth()).toEqual(width)

    describe "set/getInputHeight set invalid string value", ->
      it "should be get old value", ->
        obj = new ResizableImageView url: null
        height = 20000000
        obj.setInputHeight height
        expect(obj.getInputHeight()).toEqual(height)
        obj.setInputHeight "invalid string"
        expect(obj.getInputHeight()).toEqual(height)