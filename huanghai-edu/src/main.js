import Vue from "vue";
import "./assets/css/reset.css"
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import router from "./router"
import app from "./App.vue"//导入
import http from "./utils/http.js";
import store from "./store"//路由怎么玩，仓库就怎么玩，一样套路

Vue.use(ElementUI);
Vue.prototype.$http = http;

//根实例：创建根实例并渲染根组件
new Vue({
        el: "#app",
       // render: h => h(App)也是注册的方式
        components: { app },//注册
        template: "<app></app>",//使用
        // template: "<app />", 这样写也对，还精简
        router,
        store
});