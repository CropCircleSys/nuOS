<template>
	<div class="home">
		<div class="title">
			<h1 class="title"><em>nu</em>OS</h1>
			<h2>
				<span class="title strong">never underestimate</span>
				<span class="title wimpy">the</span>
				<span class="title legacy">old school</span>
			</h2>
			<h3>
				<span class="title shyest">sooner or later</span>
				<span class="title shyer">everything old</span>
				<span class="title shy">is <em>nu</em> again</span>
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
.home {
}
div.title {
	font-size: 3.5vmin;
}
.title {
	display: block;
}
h1.title {
	font-size: 575%;
	margin: 0.5em 0 0.33em;
}
.strong {
	transform: scaleY(2);
	font-style: italic;
}
.wimpy {
	font-variant: small-caps;
}
.wimpy:before, .wimpy:after {
	content: '⟵⟶';
	margin: 0 1em;
	letter-spacing: -0.15em;
}
.legacy {
	text-transform: uppercase;
	transform: scaleY(1.33);
	font-size: 140%;
}
.shy {
	font-size: 175%;
	letter-spacing: 0.175em;
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
