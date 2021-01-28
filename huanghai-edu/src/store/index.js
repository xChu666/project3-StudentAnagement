import Vue from "vue";
import Vuex from "vuex";
import http from "../utils/http.js";
import func from "./func.js";
import role from "./role.js";
// dictionary
import classroom from "./classroom.js";
import dictionary from "./dictionary.js";
import staff from "./staff.js";
import classs from "./classs.js";


Vue.use(Vuex);//创建vuex对象并导出

let store = new Vuex.Store( {
        //存放共用数据
        state:{//存储组件共用数据；特点其他的后面带s，state不带
                number:100,
                http,
        },
        //vuex规定：只有mutations节点中的方法才可以修改state节点中保存的数据
        //vuex规定：mutations节点中的方法在调用时第一个参数总是state本身
        //vuex规定：mutations节点中的方法组件在调用时必须用commit()来进行调用
        //vuex规定：mutations节点中的代码只能是同步的代码，不可以包含异步的耗时代码
        mutations:{
                changeNumber(state,number){
                        state.number = number
                }
        },
        //vuex规定：actions节点中的方法可以包含异步的耗时的代码，但绝对不可以修改state中的数据
        //vuex规定：actions节点中的方法在调用时第一个参数是一个仓库的上下文对象，里面包的重要属性有：state、commit、
        //vuex规定：actions节点中的方法组件调用时必须用dispatch()来进行间接调用
        actions:{},

        //拆分子仓库
        modules:{ func ,role ,classroom,dictionary,staff,classs},
        //getters相当于仓库的计算属性
        //当仓库中的state中的数据，多个组件在用时都要在经过一定的处理计算才能使用
        //可以让仓库在getters中算好后再让多个组件去用。
        getters:{},

});
//state state modules getters actions actions mutations
// mutations mutations actions getters getters state modules
// mutations mutations mutations mutations mutations
export default store//导出