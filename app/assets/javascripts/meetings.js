// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the rails generate channel command.
//
//= require action_cable
//= require_self
//= require_tree ./channels
//= require ./canvas.js
//= require ./filter.js

var setting_box = false;
var fps = 1/5;
var interval = 1000 / fps;
var mediaOptions = {
	audio: false,
	video: {
		width: 1280,
		height: 720
	}
}

// For sending images
var video, vw, vh;
var canvas, ctx;
var meetingId = -1;
var myTimeout;
var filter = false;

// For receiving images
var image;

(function() {
	this.App || (this.App = {});

	App.cable = ActionCable.createConsumer();


}).call(this);

$(document).ready(function() {
	begin();
});

function begin() {
	if (window.meeting.role == "presenter") {
		updateMedia();
		console.log("Presenting");
		navigator.mediaDevices.getUserMedia(mediaOptions).then(handleSuccess).catch(handleError);
	}
}

function startPresenting() {
	takeSnapshot();
}

function updateMedia() {
	video = $("#video-src")[0];
	vw = video.videoWidth;
	vh = video.videoHeight;
	// vw = 600;
	// vh = 450;
	console.log(vw, vh);

	canvas = $("#meeting-canvas")[0];
	canvas.width = vw;
	canvas.height = vh;
	ctx = canvas.getContext("2d");

	image = $("#incoming")[0];
	if(image.src && !filter) {
		filter = new Filter(image);
		$('#incoming').on('load', function() {
			filter.setImage(image);
			filter.trackImage();
		});
	}
}

function handleSuccess(stream) {
	updateMedia();
	video.addEventListener('loadeddata', function() {
		updateMedia();
		$(".actions").removeClass("hidden");
		meetingId = $("#meeting").data("meeting-id");
		window.meeting.id = meetingId;
		window.stream = stream;
		startPresenting();
		callSetDrawBounds(canvas, video);

	}, false);

	video.src = window.URL.createObjectURL(stream);
}

function callSetDrawBounds(canvas, video) {
	$(".set-box").on("click", setDrawBounds($(".set-box"), canvas, video, function() {
		setting_box = true;
		console.log("hello");
		console.log(myTimeout);
		clearTimeout(myTimeout);
		$("img").addClass("hidden");
		$(canvas).removeClass("hidden");
	}, function() {
		setting_box = false;
		console.log("GOODBYE");
		$(canvas).addClass("hidden");
		$("img").removeClass("hidden");
		App.meeting.send_box(window.meeting.current_id, meetingId, coordSrc, coordEnd);
		startPresenting();
	}));
}

function handleError(error) {
	console.error('navigator.getUserMedia error: ', error);
}

function takeSnapshot() {
	updateMedia();
	if (window.stream && !setting_box) {
		console.log("Snap");
		ctx.drawImage(video, 0, 0, vw, vh);
		var imgData = canvas.toDataURL();
		var suffix = Date.now();
		// var suffix = new Date(Date.now());
		// suffix = suffix.toLocaleTimeString().slice(0,-3);
		var fileName = "IMG_" + suffix + ".png";

		App.meeting.send_image(window.meeting.current_id, fileName, imgData, meetingId);
	} else {
		console.warn("Snapshot failed");
	}
}
