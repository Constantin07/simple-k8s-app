var express = require('express');
var exphbs  = require('express-handlebars');
var app = express();
var os = require("os");
var morgan = require('morgan');
var router = express.Router();

app.engine('handlebars', exphbs.engine({extname: '.handlebars', defaultLayout: 'main'}));
app.set('view engine', 'handlebars');
app.use(express.static('static'));
app.use(morgan('combined'));

console.log('Reading Vault secrets');
const creds = process.env.SECRET_DATA;

const port = process.env.PORT || 8080;
const message = process.env.MESSAGE || "Hello world!";
const namespace = process.env.NAMESPACE || "None";
const app_version = process.env.APP_VERSION || "unknown";

app.get('/', function (req, res) {
    // Get client IP
    var x_forwarded_for = req.get('X-Forwarded-For') || 'Header not set';

    res.render('home', {
	message: message,
	platform: os.type(),
	release: os.release(),
	hostName: os.hostname(),
	namespace: namespace,
	xForwardedFor: x_forwarded_for,
	creds: JSON.stringify(creds)
    });
});

// Health check
router.get('/', function (req, res, next) {
    res.json({status: 'UP', app_version: app_version});
});

app.use("/health", router);

// Set up listener
app.listen(port, function () {
    console.log("Listening on: http://%s:%s", os.hostname(), port);
});
