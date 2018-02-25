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
h1.title {
	font-size: 575%;
	margin: 0.5em 0 0.33em;
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
	margin: 0.5em 0 0.33em;
}
.wimpy:before, .wimpy:after {
	content: '⟵⟶';
	margin: 0 2.75em;
	letter-spacing: -0.15em;
}
.legacy {
	text-transform: uppercase;
	transform: scaleY(1.5);
	font-size: 140%;
	color: White;
}
.shy {
	font-size: 175%;
	letter-spacing: 0.175em;
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
