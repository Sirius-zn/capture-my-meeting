class Filter {
  constructor(canvas, video) {
    this.canvas = canvas;
    this.video = video;
    this.currentImage = [];
    this.currentFrame = []
    this.tracker = undefined;

    init()
  }

  Filter.prototype.subtractCurrentWith = function(newImage) {
    // Subtract here
    for(var i = 0; i < currentImage.length; i++) {
      this.currentImage[i] = this.currentImage[i] - newImage[i];
    }
  }

  Filter.prototype.getBoundingBoxFrom = function(image) {
    var tracker = new tracking.ColorTracker(['green']);
    tracking.track(image, tracker, {});

    tracker.on('track', function()
  }

  // Private functions
  function init() {
    // Initialize Current Image to size of canvas / video
    for(var i = 0; i < canvas.width * canvas.height; i++) {
      this.currentImage.push(0);
      this.currentFrame.push(0);
    }

    tracking.ColorTracker.registerColor('green', function(r, g, b) {
      if(r > 50 && r < 143 && g > 120 && g < 170 && b > 110 && b < 150) {
        return true;
      } else {
        return false;
      }
    });

    this.tracker = new tracking.ColorTracker(['green']);
    this.tracker.setMinGroupSize(1);
    tracking.track(this.video, tracker, {});

    this.tracker.on('track', function(event) {
      this.currentFrame = getBox(event);
    });

    function getBox(event) {
      var frame = []
      for(var i = 0; i < canvas.width * canvas.height; i++) {
        frame.push(0);
      }

      if(event.data.length == 0) {
        console.log('nothing found');
      } else {
        event.data.forEach(function(rect) {
          // Store rectangles
          for(var i = 0; i < rect.height; i++) {
            for(var j = 0; j < rect.width; j++) {
              frame[canvas.width * (rect.y + i) + rect.x + j] = 1;
            }
          }
        });
      }

      return frame;
    }
}
