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
	</div>
</template>

<script>
export default {
	name: 'Home',
	data () {
		return {
			msg: 'foo bar baz buz'
		}
	}
}
</script>

<style scoped>
div.title {
	font-size: 3.5vmin;
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
.shy em, h1.title em {
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
