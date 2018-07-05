const {barcode, qrcode, svg2url} = require('pure-svg-code');
const jsdom = require('jsdom').JSDOM;

const argv = process.argv.slice(2);

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
	width: 760,
	height: 538,
	color: '#ffffff',
	background: '#0000ff',
	ecl: 'H'
});

const bd = jsdom.fragment(barCode);
const qd = jsdom.fragment(qrCode);

var flag = '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 1900 1000"><g transform="rotate(-90) translate(-1000 0)"><g>';

for (var n of bd.childNodes[0].childNodes) {
	flag += n.outerHTML;
}

flag += '</g><g transform="rotate(90 950 500) translate(450 450)">';

var re = /style="fill: ?#(......); ?shape-rendering: ?crispEdges;?"/g;
for (var n of qd.childNodes[1].childNodes) {
	flag += n.outerHTML.replace(re, "fill=\"#$1\"");
}

flag += '</g></g></svg>';

console.log(flag);
