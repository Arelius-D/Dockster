import { createRouter, createWebHistory } from 'vue-router';
import App from '../App.vue'; 
import Logs from '../components/Logs.vue';

const routes = [
  { path: '/', component: App },
  { path: '/logs', component: Logs },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
