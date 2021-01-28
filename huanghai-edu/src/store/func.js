import http from "../utils/http.js";

export default {
        namespaced:true,//后面有个d!!!!
        //namespaced    namespaced namespaced namespaced
        state:{
                list:[],
                isInit:false,
        },
        getters:{
                listToTree(state){
                        let result = [];
                        state.list.filter( item => item.func_fid === 0 ).forEach( item => {
                                let node = Object.assign({} , item);
                                let children = state.list.filter( func => func.func_fid === item.func_id );
                                if( children.length > 0 ){
                                        node.children = [];
                                        children.forEach( func => node.children.push(Object.assign({}, func)));
                                }
                                result.push(node);//所以这里找第一个对象里的children进行添加
                        } );
                        return result;
                },
        },
        mutations:{
                _init(state,list){//初始化
                        state.list = list;
                        state.isInit = true;
                },
                _removeFunc(state,func_id){//删除
                        let i = state.list.findIndex(item => item.func_id === func_id);
                        state.list.splice(i,1);
                },
                _addFunc(state,func){
                        state.list.push(func);
                },
                _updateFunc(state,func){
                        let i = state.list.findIndex(item => item.func_id === func.func_id);
                        state.list.splice(i,1,func);
                }

        },
        actions:{
                async init(context){//初始化
                        if(context.state.isInit) return;
                        let list = await http({ url: "/function/all" });
                        context.commit("_init",list);
                },
                async removeFunc(context,func_id){//删除
                        await http({ method:"post",url:"/function/remove/" + func_id })
                        context.commit("_removeFunc",func_id);
                },
                async addFunc(context,func){
                        func.func_id = await http({ url: "/function/add", method: "post", data: func });
                        context.commit("_addFunc",func);
                },
                async updateFunc(context,func){
                        let func_id = await http({  url: "/function/update",method: "post",data: func});
                        context.commit("_updateFunc",func);
                }
        },
}