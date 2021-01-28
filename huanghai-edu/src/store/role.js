import http from "../utils/http.js"

export default {
        namespaced: true,
        state:{
                rolesList:[],
                isRendering:false,
        },
        mutations:{
                _isRendering(state,list){
                        state.rolesList = list;
                        state.isRendering = true;
                },
                _removeRole(state,role_id){
                        let i = state.rolesList.findIndex(item => item.role_id === role_id);
                        state.rolesList.splice(i, 1);
                },
                _addRole(state,role){
                        state.rolesList.push(role)
                },
                _updateRole(state,role){
                        let i = state.rolesList.findIndex(item => item.role_id === role.role_id);
                        state.rolesList.splice(i, 1, role)
                }
        },
        actions:{
                async isRendering(context){
                        if(context.state.isRendering) return;
                        let rolesList = await http({url: "/role/all"});
                        context.commit("_isRendering" ,rolesList)
                },
                async removeRole(context,role_id){
                        await http({method: "post", url: "/role/remove/" + role_id,});
                        context.commit("_removeRole",role_id)
                },
                async addRole(context,role){
                        role.role_id = await http({ method: "post", url: "/role/add",  data: role });
                        context.commit("_addRole",role)
                },
                async updateRole(context,role){
                        await http({ method: "post", url: "/role/update", data: role })
                        context.commit("_updateRole",role)
                }

        },
}