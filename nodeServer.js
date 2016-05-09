var net = require('net');
var io = require('socket.io-client');

var HOST = '192.168.1.39'; // parameterize the IP of the Listen
var PORT = 5000; // TCP LISTEN port
var serverURL="http://192.168.1.39:8000";
var socket;
//接続からハンドラの登録までをまとめる
function connect(uri){
    socket = io.connect(uri);//接続
    //接続時のイベント
    socket.on('connect', function() {
        //受信イベントハンドラ
        socket.on('sample event', function (data) {
            console.log(JSON.stringify(data));
        });
        //切断時の処理
        socket.on('disconnect', function (data) {
            console.log("disconnected");
        });
        //"Client"roomに入る
        socket.emit('enter_room',{room:"Controller"})
    });
}
//どこかの処理でconnect(uri)を呼ぶと接続できる
connect(serverURL);


// Create an instance of the Server and waits for a conexão
net.createServer(function(sock) {


  // Receives a connection - a socket object is associated to the connection automatically
  console.log('CONNECTED: ' + sock.remoteAddress +':'+ sock.remotePort);


  // Add a 'data' - "event handler" in this socket instance
  sock.on('data', function(data) {
	  // data was received in the socket 
	  // Writes the received message back to the socket (echo)
	console.log("recieved"+data);
	var angle;
	try{
		angle=parseFloat(data);
	}catch(e){
		angle=null
	}
	socket.emit('transfer',{
        'event':"Controller Data",
        'room':["Game"],
        'data':angle
	});
	//sock.write(data);
  });


  // Add a 'close' - "event handler" in this socket instance
  sock.on('close', function(data) {
	  // closed connection
	  console.log('CLOSED: ' + sock.remoteAddress +' '+ sock.remotePort);
  });


}).listen(PORT, HOST);


console.log('Server listening on ' + HOST +':'+ PORT);


//Read more: http://mrbool.com/communicating-node-js-and-java-via-sockets/33819#ixzz489Nmp7MY

