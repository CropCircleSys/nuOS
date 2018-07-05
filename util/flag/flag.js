const {barcode, qrcode, svg2url} = require('pure-svg-code');
const jsdom = require('jsdom').JSDOM;

const argv = process.argv.slice(2);

var tr, vert = false;

if (argv[0] == '-h' || argv[0] == '--') {
	argv.shift();
} else if (argv[0] == '-v') {
	vert = true
	argv.shift();
}

if (vert) {
	tr = '';
	qtr = '';
	vb = '1000 1900';
	qw = 538;
	qh = 760;
} else {
	tr = ' transform="rotate(-90) translate(-1000 0)"';
	qtr = ' transform="rotate(90 950 500) translate(450 450)"';
	vb = '1900 1000';
	qw = 760;
	qh = 538;
}

const barCode = barcode(
	argv[0],
	'code128',
	{
		width: 1000,
		barHeight: 1900,
		color: '#ff0000',
		bgColor: '#ffffff'
});

const qrCode = qrcode({
	content: argv[1],
	padding: 3,
	width: qw,
	height: qh,
	color: '#ffffff',
	background: '#0000ff',
	ecl: 'H'
});

const bd = jsdom.fragment(barCode);
const qd = jsdom.fragment(qrCode);

var flag = '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 ' + vb + '"><g' + tr + '><g>';

for (var n of bd.childNodes[0].childNodes) {
	flag += n.outerHTML;
}

flag += '</g><g' + qtr + '>';

var re = /style="fill: ?#(......); ?shape-rendering: ?crispEdges;?"/g;
for (var n of qd.childNodes[1].childNodes) {
	flag += n.outerHTML.replace(re, "fill=\"#$1\"");
}

flag += '</g></g></svg>';

console.log(flag);
