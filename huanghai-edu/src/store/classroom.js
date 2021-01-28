import http from "../utils/http.js"

export default {
        namespaced:true,
        state:{
                classRoomList:[],
                isUsedClass:false,
        },
        mutations:{
                _isUsedClass(state,list){
                        state.classRoomList = list;
                        state.isUsedClass = true;
                        console.log(list);
                },

                _addClassRoom(state,room){
                        room.clsr_occupy = 0;
                        state.classRoomList.push(room);
                },
                _editClassRoom(state,room){
                        let i = state.classRoomList.findIndex(item => item.clsr_id === room.clsr_id);
                        state.classRoomList.splice(i,1,room)
                },
                _removeClassRoom(state,clsr_id){
                        let i = state.classRoomList.findIndex(item => item.clsr_id === clsr_id);
                        state.classRoomList.splice(i,1)
                }
        },
        actions:{
                async isUsedClass(context){
                        if(context.state.isUsedClass) return;
                        let roomList = await http({url:"/classroom/all"});
                        context.commit("_isUsedClass",roomList)
                },
                async addClassRoom(context,room){
                        room.clsr_id = await http({ method:"post" ,url:"/classroom/add",data:room});
                        context.commit("_addClassRoom",room)
                },
                async editClassRoom(context,room){
                        await http({ method:"post",url:"/classroom/update",data:room });
                        context.commit("_editClassRoom",room)
                },
                async removeClassRoom(context,clsr_id){
                        await http({url: "/classroom/remove/" + clsr_id})
                        context.commit("_removeClassRoom",clsr_id)
                }

        },
}