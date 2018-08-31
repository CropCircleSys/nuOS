import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Get from '@/components/Get'
import Conduct from '@/components/Conduct'
// import HelloWorld from '@/components/HelloWorld'
import NotFound from '@/components/NotFound'

Vue.use(Router)

export default new Router({
	mode: 'history',
	// Apache config:
	// RewriteCond "%{LA-U:REQUEST_FILENAME}" !-f
	// RewriteCond "%{LA-U:REQUEST_FILENAME}" !-d
	// RewriteRule . "%{CONTEXT_DOCUMENT_ROOT}/index.html" [nosubreq]
	routes: [
		{
			path: '/',
			name: 'Home',
			component: Home
		},
		// {
		// 	path: '/hello',
		// 	name: 'HelloWorld',
		// 	component: HelloWorld
		// },
		{
			path: '/get',
			name: 'Get',
			component: Get
		},
		{
			path: '/coc',
			name: 'CoC',
			component: Conduct
		},
		{
			path: '*',
			component: NotFound
		}
	]
})
