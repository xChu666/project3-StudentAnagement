import http from '../utils/http.js';
export default {
        namespaced:true,
        state:{
                dictionary:[],
                isInit:false,
        },
        getters:{
                getGroupByKey(state){
                        return function(groupKey){
                                return state.dictionary.filter(item => item.dic_group_key === groupKey)
                        }
                },
                staffCategory(state){//职务类别
                        return state.dictionary.filter(item => item.dic_group_key === "staff_category")
                },
                // classMajor(state){//班级专业
                //         return state.dictionary.filter(item => item.dic_group_key === "class_major")
                // }

        },
        mutations:{
                _init(state,dictionary){
                        state.dictionary=dictionary;
                        state.isInit=true;
                },
        },
        actions:{
                async dictionaryInit(context){
                        if(context.state.isInit) return;
                        let dictionary = await http({url:'/dictionary/all'});
                        context.commit('_init',dictionary)
                },
        },
};