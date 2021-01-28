export default {
        namespaced:true,
        state:{
                classAll:[],//所有班级详细信息
                classList:{
                        list:[],
                        total:0,
                },//班级
        },
        getters:{
                getClassAllMax(state){
                        let classAllMax = [];
                        let cls_status = 0;
                        state.classList.list.forEach(item => {
                                Object.assign(item,{cls_status})
                        });
                        classAllMax = state.classList.list;
                        classAllMax.forEach(item => {
                                if(item.cls_begin ===null) item.cls_status = 2;
                                else if(item.cls_end ===null) item.cls_status = 1;
                                else item.cls_status = 3;
                        })
                        return classAllMax;
                }
        },
        mutations:{
                _isClassAll(state,classAll){
                        state.classAll = classAll;
                        console.log(classAll);
                },
                _isClassList(state,classList){
                        state.classList = classList;
                        console.log(classList);
                },
                _beginAddClass(state,addList){
                        state.classList.list.push(addList);
                        state.classAll.push(addList);
                },
                _beginEditClass(state,editList){
                        let i = state.classList.list.findIndex(item => item.cls_id === editList.cls_id);
                        state.classList.list.splice(i,1,editList);
                },
                // _beginClass(state,beginClass){
                //         let i = state.classList.list.findIndex(item => item.cls_name === beginClass.cls_name);
                //         state.classList.list.splice(i,1,beginClass);
                //         let j = this.classRoomList.findIndex(item => item.clsr_id === beginClass.clsr_id);
                //         console.log(j);
			// this.classRoomList[j].clsr_occupy = 1;
                // },
                // _goingClass(state,goingClass){
                //         let i = state.classList.list.findIndex(item => item.cls_name === goingClass.cls_name);
                //         state.classList.list.splice(i,1,goingClass);
                // }

        },
        actions:{
                async isClassAll({commit,rootState}){
                        let classAll = await rootState.http({url:"/class/all"});
                        commit("_isClassAll",classAll);
                },
                async isClassList( {commit,rootState},getList){
                        let classList = await rootState.http({url:"/class/list",method:"post",data:getList});
                        commit("_isClassList",classList);
                },
                async beginAddClass({commit,rootState},addList){
                        let classId = await rootState.http({ url:"/class/add",method:"post",data:addList  });
                        addList.cls_id = classId;
                        commit("_beginAddClass",addList);
                },
                async beginEditClass({commit,rootState},editList){
                        await rootState.http({ url:"/class/update",method:"post",data:editList  });
                        commit("_beginEditClass",editList);
                },
                // async beginClass({commit,rootState},beginClass){
                //         let beginTime = await rootState.http({ url:"/class/begin",method:"post",data:beginClass });
                //         beginClass.cls_begin = beginTime
                //         commit("_beginClass",beginClass);
                // },
                // async goingClass({commit,rootState},goingClass){
                //         let endTime = await rootState.http({ url:"/class/end",method:"post",data:goingClass });
                //         goingClass.cls_end = endTime;
                //         commit("_goingClass",goingClass);
                // }
        },
}