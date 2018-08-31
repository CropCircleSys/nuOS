<template>
	<div class="home">
		<div class="title">
			<h1 class="title"><em>nu</em>OS</h1>
			<h2>
				<span class="bl strong">never underestimate</span>
				<span class="bl wimpy">the</span>
				<span class="bl legacy">old school</span>
			</h2>
			<h3>
				<span class="bl shyest">sooner or later</span>
				<span class="bl shyer">everything old</span>
				<span class="bl shy">is <em>nu</em> again</span>
			</h3>
		</div>
		<div class="log-xrpt">
			<h1>Happy Independence Day!</h1>
			<img src="static/svg/flag.3492b1e945b36a28d013fcc2911b9809.svg"/>
			<h2>A new version of nuOS is <del>coming</del> <ins datetime="2018-07-05">here</ins>.</h2>
			<h4><time datetime="2018-07-04">July 4, 2018</time></h4>
			<p>After you sleep off the night&rsquo;s celebration of a great nation born, a new build of nuOS <del>should be</del> <ins datetime="2018-07-05">is now</ins> available for download. By the time you&rsquo;re barely ready to return to work in the morning, <del>it&rsquo;ll be</del> <ins datetime="2018-07-05">it <strong>is</strong></ins> time to celebrate your technological independence using the most featurefull nuOS ever. Version 0.11.2a1, available now as source, is building as I write this.</p>
			<p>For now it&rsquo;s time to go get deplorably inebriated and hazardously detonate some unregulated ordnance like a true &lsquo;Murican.</p>
			<h5>(updated: <time datetime="2018-07-04">July 5, 2018</time>)</h5>
		</div>
	</div>
</template>

<script>
export default {
	name: 'Home',
	data () {
		return {}
	}
}
</script>

<style scoped>
div.log-xrpt time, div.log-xrpt ins {
	font-style: italic;
}
div.log-xrpt del {
	text-decoration: line-through red double;
}
div.log-xrpt ins {
	text-decoration: underline red solid;
}
div.log-xrpt p {
	text-align: left;
}
@media screen and (min-width: 769px) {
	div.log-xrpt {
		position: fixed;
		top: calc(2vmin + 6vw);
		right: 0;
		width: 20vw;
		z-index: 1;
		margin: 0 1em;
	}
}
@media screen and (max-width: 768px) {
	div.log-xrpt {
		margin: 2em 12vw;
	}
}
div.log-xrpt h1 {
	font-size: 1.33em;
}
div.log-xrpt h2 {
	font-size: 1.2em;
}
div.log-xrpt h3 {
	font-size: 1em;
}
div.title {
	font-size: 3.5vmin;
	color: LightGray;
}
div.log-xrpt {
	font-size: calc(9pt + 0.5vmin);
	color: LightGray;
}
.bl {
	display: block;
}
.title h3 {
	border-width: thin;
	border-left: 0;
	border-right: 0;
	border-style: solid;
	width: 12.75em;
	margin: 0 auto;
	padding: 0 0 0 0.1em;
}
h1.title:before, h1.title:after {
	display: block;
	text-transform: uppercase;
	font-size: 8.75%;
	font-weight: initial;
	border-width: thin;
	border-left: 0;
	border-right: 0;
	border-style: solid;
	width: 33em;
	padding: 0 0 0 1em;
}
h1.title:before {
	letter-spacing: 1.3em;
	content: 'next underground';
	margin: 0 auto -5.25em;
}
h1.title:after {
	letter-spacing: 1.35em;
	content: 'operating system';
	margin: -2.75em auto 0;
}
h1.title {
	font-size: 500%;
	margin: 0.75em 0 0.33em;
}
.strong {
	transform: scaleY(2);
	font-style: italic;
	color: White;
}
.wimpy {
	font-variant: small-caps;
	font-size: 50%;
	letter-spacing: 0.33em;
	margin: 0.5em 0 0.33em 0.33em;
}
.wimpy:before, .wimpy:after {
	display: inline-block;
	transform: scaleX(2);
	content: '⟵⟶';
	margin: 0 3em 0 2.5em;
	letter-spacing: -0.15em;
}
.legacy {
	text-transform: uppercase;
	transform: scaleY(1.5);
	font-size: 140%;
	color: White;
}
.shy {
	font-size: 167%;
	letter-spacing: 0.175em;
	margin: -0.25em 0 0;
}
.shy em {
	color: White;
}
.shyer {
	font-size: 140%;
	letter-spacing: 0.16em;
}
.shyest {
	font-size: 135%;
	letter-spacing: 0.15em;
}
</style>
