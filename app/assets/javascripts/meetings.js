// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the rails generate channel command.
//
//= require action_cable
//= require_self
//= require_tree ./channels
//= require ./canvas.js

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

var peers = [];

(function() {
	this.App || (this.App = {});

	App.cable = ActionCable.createConsumer();


}).call(this);

call_all_peers = function(rPeers) {
	console.log('peers in call all peers: ' + rPeers);
	peers = rPeers;
	console.log('global peers: ' + peers);
	var audioMediaOptions = {
		audio: true,
		video: false
	}
	navigator.mediaDevices.getUserMedia(audioMediaOptions).then(audioHandleSuccess).catch(audioHandleError);
	console.log('after getUserMedia');
}

audioHandleSuccess = function(stream) {
	console.log('in audioHandleSuccess');
	console.log('peers: ' + peers);
	var count = 1;
	peers.forEach(function(otherPeer) {

		// //Make connection PROGBABLY NOT NEEDED
		// var conn = meeting.peer.connect(otherPeer);
		// conn.on('open', function() {
		// 	//Receive messages
		// 	conn.on('data', function(data) {
		// 		console.log('Received data from peer: ' + data);
		// 	});
		//
		// 	//Send message
		// 	conn.send('Hello from peer');
		// });
		//
		// //Receive connection
		// meeting.peer.on('connection', function(rConn) {
		// 	console.log('Received Connection from peer');
		// });


		//Call peer TODO fix TypeError: b is undefined
		var call = meeting.peer.call(otherPeer, stream);
		console.log('calling peer');

		call.on('stream', function(rStream) {
			console.log("receiving stream");
			// window.stream = stream;
		});
	});

	meeting.peer.on('call', function(call) {
		console.log('answering call from peer');
		call.answer(stream);
	});
}

audioHandleError = function(error) {
	console.log('audio getUserMedia error: ' + error);
}

$(document).ready(function() {
	begin();
});

function begin() {
	if (window.meeting.role == "presenter") {
		console.log("Presenting")
		navigator.mediaDevices.getUserMedia(mediaOptions).then(handleSuccess).catch(handleError);
	}
}

function startPresenting() {
	if (!setting_box) {
		myTimeout = setTimeout(function() {
			updateMedia();
			takeSnapshot();
			startPresenting();
		}, interval);
	} else {
		console.warn("D:");
	}
}

function updateMedia() {
	video = $("#video-src")[0];
	vw = $(video).width();
	vh = $(video).height();

	canvas = $("#meeting-canvas")[0];
	canvas.width = $(video).width();
	canvas.height = $(video).height();
	ctx = canvas.getContext("2d");
}

function handleSuccess(stream) {
	updateMedia();
	meetingId = $("#meeting").data("meeting-id");
	window.stream = stream;
	video.src = window.URL.createObjectURL(stream);
	startPresenting();
	callSetDrawBounds(canvas, video);
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
		App.meeting.send_box(window.meeting.current_id, window.meeting.id, coordSrc, coordEnd);
		startPresenting();
	}));
}

function handleError(error) {
	console.error('navigator.getUserMedia error: ', error);
}

function takeSnapshot() {
	if (window.stream && !setting_box) {
		console.log("Snap");
		ctx.drawImage(video, 0, 0, vw, vh);
		var imgData = canvas.toDataURL();
		var suffix = Date.now();
		// var suffix = new Date(Date.now());
		// suffix = suffix.toLocaleTimeString().slice(0,-3);
		var fileName = "IMG_" + suffix + ".png";

		App.meeting.send_image(window.meeting.current_id, fileName, imgData, meetingId, coordSrc, coordEnd);
	} else {
		console.log(":()");
	}
}
