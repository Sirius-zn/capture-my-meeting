var coordSrc, coordEnd;
var dragging = false;

function setDrawBounds(btn, canvas, video, f1, f2) {
	btn.on("click", function(e) {
		f1();
		specifyWhiteboardBounds(canvas, video);

		// Set
		$(this).off("click");
		$(this).html("Save bounds");
		$(this).on("click", function(e) {
			// Send coordinates
			f2();
			if (coordSrc != undefined && coordEnd != undefined) {
				$(this).off("click");

				// turn off event listeners
				$(canvas).off("mousedown");
				$(canvas).off("mouseup");
				$(canvas).off("mouseover");
				$(canvas).off("mouseout");


				$(this).html("Set Boundaries");
			} else {
				console.error("Attempted to set non-existing bounds");
			}

			setDrawBounds(btn, canvas, video, f1, f2)
		});
	});
}

function specifyWhiteboardBounds(canvas, video) {
	ctx = canvas.getContext("2d");

	if (window.stream) {
		ctx.drawImage(video, 0, 0, $(video).width(), $(video).height());
		bg = new Image;
		bg.src = canvas.toDataURL()

		// Draw bounding box if it exists
		if (coordSrc != undefined || coordEnd != undefined) {
			updateCanvas(ctx);
		}

		// Events to draw the region
		$(canvas).mousedown(function(e) {
			coordSrc = getCanvasPos({ x: e.pageX, y: e.pageY }, this);
			dragging = true;
		});

		$(canvas).mouseup(function(e) {
			coordEnd = getCanvasPos({x: e.pageX, y: e.pageY}, this);
			dragging = false;
		});

		$(canvas).mousemove(function(e) {
			if(dragging) {
				coordEnd = getCanvasPos({x: e.pageX, y: e.pageY}, this);
				updateCanvas(ctx);
			}
		});

		$(canvas).mouseout(function(e) {
			if (dragging) {
				if (e.pageX > this.width + this.offsetLeft) {
					coordEnd = getCanvasPos({x: this.width, y: e.pageY}, this);
				}

				if (e.pageY > this.height + this.offsetTop) {
					coordEnd = getCanvasPos({x: e.pageX, y: this.height}, this);
				}

				updateCanvas(ctx);
			}
		});
	} else {
		console.error("Stream is null");
	}
}

// Animates drawing rectangle
function updateCanvas(ctx) {
	ctx.drawImage(bg, 0, 0);
	ctx.strokeStyle = "#FFFFFF";
	ctx.lineWidth = 5;
	ctx.strokeRect(coordSrc.x, coordSrc.y, coordEnd.x - coordSrc.x, coordEnd.y - coordSrc.y);
}

// Change of coordinate system from World -> NDC -> Canvas
// Returns the coordinates for the canvas
function getCanvasPos(world, canvas) {
	var canvasPoint = {};
	canvasPoint.x = 0;
	canvasPoint.y = 0;

	// World Coordinates
	canvasPoint.x = world.x - canvas.offsetLeft;
	canvasPoint.y = world.y - canvas.offsetTop;

	// NDC
	canvasPoint.x /= $(canvas).width();
	canvasPoint.y /= $(canvas).height();

	// Canvas Land
	canvasPoint.x *= canvas.width;
	canvasPoint.y *= canvas.height;

	return canvasPoint;
}
