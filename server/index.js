var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);


//Whenever someone connects this gets executed
io.on('connection', function (socket) {
    console.log('Socket backend ishga tushdi!');

    socket.join('socketchat');

    //Whenever someone disconnects this piece of code executed
    socket.on('disconnect', function () {
        console.log('A user disconnected');
    });

    socket.on('xabarYuborish', function (xabar) {
        io.to('socketchat').emit('xabarKeldi', xabar);
    });
});

http.listen(3000, function () {
    console.log('listening on *:3000');
});