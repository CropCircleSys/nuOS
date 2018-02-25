<template>
	<div id="app">
		<router-view/>
	</div>
</template>

<script>
import 'normalize.css'
export default {
	name: 'App'
}
</script>

<style>
body {
	background: Black;
}
#app {
	text-align: center;
	font-family: "Lucida Bright", Georgia, serif;
	color: White;
}
h1, h2, h3 {
	font-family: Baskerville, "Hoefler Text", Garamond, "Times New Roman", serif;
}
</style>
