class Filter {

  constructor(img) {
    console.log('image: ' + img);
    this.img = img;
    this.pixelArray = [];
    this.tracker = undefined;
    this.init();
  }

  setImage(image) {
    this.img = image;
  }

  getBox(event) {
    var frame = []
    for(var i = 0; i < this.img.width * this.img.height; i++) {
      frame.push(0);
    }
    var self = this;

    if(event.data.length == 0) {
      console.log('no green detected');
    } else {
      event.data.forEach(function(rect) {
        // Store rectangles
        for(var i = 0; i < rect.height; i++) {
          for(var j = 0; j < rect.width; j++) {
            frame[self.img.width * (rect.y + i) + rect.x + j] = 1;
          }
        }
      });
    }

    return frame;
  }

  emptyPixelArray() {
    for(var i = 0; i < this.img.height * this.img.width; i++) {
      this.pixelArray.push(0);
    }
  }

  replaceGreen() {
    var self = this;

    //create temporary canvas
    var c = document.createElement('canvas');
    // var c = document.getElementById('temp');
    var ctx = c.getContext('2d');
    var w = this.img.width;
    var h = this.img.height;
    c.width = w;
    c.height = h;
    ctx.drawImage(this.img, 0, 0, w, h);
    var imageData = ctx.getImageData(0, 0, w, h);

    for(var i = 0; i < imageData.data.length; i += 4) {
      if(self.pixelArray[i/4]) {
        imageData.data[i] = 255;
        imageData.data[i+1] = 255;
        imageData.data[i+2] = 255;
      }
    }

    ctx.putImageData(imageData, 0, 0);
    this.img.src = c.toDataURL('image/png');
  }

  trackImage() {
    tracking.track(this.img, this.tracker);
    var self = this;

    this.tracker.on('track', function(event) {
      self.emptyPixelArray();
      self.pixelArray = self.getBox(event);
      self.replaceGreen();
    });
  }

  init() {

    console.log('initializing filter');
    this.emptyPixelArray();
    console.log('intialized pixel array');

    tracking.ColorTracker.registerColor('green', function(r, g, b) {
      if( r > 50 && r < 143 && g > 120 && g < 170 && b > 110 && b < 150) {
        return true;
      } else {
        return false;
      }
    });
    console.log('registered green');

    this.tracker = new tracking.ColorTracker(['green']);
    this.tracker.setMinGroupSize(1);
    console.log('initailized tracker settings');
    this.trackImage();

  }

}
