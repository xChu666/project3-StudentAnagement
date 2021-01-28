<template>
	<div>
		<el-tree :data="treeData" default-expand-all class="custom-tree" :expand-on-click-node="false">
			<span slot-scope="{node,data}" class="custom-tree-node">
				<!-- 有且只有一个根节点才能slot-scope  -->
				<span v-text="data.func_name" :class="{ root : data.func_id === 0, unleaf : data.func_key === '',leaf:data.func_key !== ''}"></span>
				<el-form :label-position="labelPosition" label-width="150px" :model="edit.model" :rules="edit.rules" ref="from">
					<el-button type="text" v-if="data.func_key === ''" @click="addData(data)"><i class="el-icon-plus"></i></el-button>
					<el-button type="text" v-if="data.func_id != 0" @click="edtiData(data)"><i class="el-icon-edit"></i></el-button>
					<el-button type="text" v-if="[0,44,45].indexOf(data.func_id) === -1" :disabled="typeof (data.children) !== 'undefined'" @click="remove(data)"><i class="el-icon-delete"></i></el-button>
				</el-form>
			</span>
		</el-tree>
		<el-dialog :modal="false" :title="edit.isWord === true? '新增节点':'编辑节点'" :visible.sync="edit.isEdit"  width="550px" >
			<!-- 表单中内容 -->
			<el-form :label-position="labelPosition" label-width="150px" :model="edit.model" :rules="edit.rules" ref="from">
				<el-form-item label="系统功能类型：">
					<el-radio v-model="edit.isLeaf" :label="true" :disabled="!(edit.isNew && edit.model.func_fid === 0)">叶子节点</el-radio>
					<el-radio v-model="edit.isLeaf" :label="false":disabled="!(edit.isNew && edit.model.func_fid === 0)">非叶子节点</el-radio>
				</el-form-item>

				<el-form-item label="父节点名称：">
					<el-select v-model="edit.model.func_fid"  :disabled="edit.isNew || !edit.isLeaf">
						<el-option v-for="item in selectData" :label="item.label" :value="item.value" :key="item.value"></el-option>
					</el-select>
				</el-form-item>

				<el-form-item label="系统功能名称：" prop="func_name">
					<el-input v-model.trim="edit.model.func_name" placeholder="请输入系统功能名称"></el-input>
				</el-form-item>

				<el-form-item label="系统功能关联组件："  v-show="edit.isLeaf" prop="func_key">
					<el-select placeholder="请选择系统功能关联组件" v-model="edit.model.func_key">
						<el-option v-for="item in Object.keys(Views)" :label="item" :value="item" :key="item" :disabled="list.findIndex(func => func.func_key=== item) !== -1"></el-option>
					</el-select>
				</el-form-item>
			</el-form>

			<span slot="footer" class="dialog-footer">
			    <el-button type="primary" @click="sureAdd" v-text="edit.isWord === true? '确定':'保存'"></el-button>
			    <el-button @click="edit.isEdit = false">取 消</el-button>
			  </span>

		</el-dialog>
	</div>
</template>

<script type="text/ecmascript-6">
	import Views from "../../views";
	import { createNamespacedHelpers } from "vuex";
	let { mapState , mapGetters , mapActions} = createNamespacedHelpers("func");
        export default {
                name: "Func",
	        data(){
                        return {
                                Views,
                                labelPosition:"right",
	                        edit:{
                                        isWord:true,//文字
	                                isEdit:false,//是否进入编辑状态
		                        isLeaf:true,//当前是叶子结点还是非叶子节点//默认选择
		                        isNew:true,//true新增，false修改
		                        model:{func_id:0,func_name:"",func_key:"",func_fid:-1},
                                        rules:{
                                                func_name:[{
							//自定义验证
	                                                validator:(rule,value,callback) => {
								//ES6中的解构赋值
		                                                let {func_id,func_name,func_fid} = this.edit.model;
		                                                if(value.length === 0){
									callback(new Error('*功能名不能为空'))
		                                                }
		                                                else if(value.length<2 || value.length>50){
                                                                        callback(new Error('*功能名长度2-50'))
                                                                }
                                                                else if(this.list.some(item => item.func_id !== func_id && item.func_name === func_name && item.func_fid === func_fid)){
									callback(new Error("功能名称在当前父级中已经存在"))
		                                                }
		                                                else{
                                                                        callback()
		                                                }
	                                                },
	                                                trigger:"blur"
                                                }],
                                                func_key:[{
                                                        validator:(rule,value,callback) => {
                                                                if(this.edit.model && this.edit.isLeaf && value === ""){
                                                                        callback(new Error('*叶子节点必须绑定组件！'))
                                                                }
                                                                else{
                                                                        callback()
                                                                }
                                                        },
                                                        trigger:"blur"
                                                }]
                                        }
	                        }
                        }
	        },
		computed:{
			...mapState(["list"]),//...展开运算符
			...mapGetters(["listToTree"]),
	                treeData(){
                                return [ {
                                        func_id: 0,
	                                func_name:"Root",
	                                func_key:"",
	                                func_fid:-1,
	                                children:this.listToTree,
//	                                children: this.$store.getters["func/listToTree"],
                                } ];//创造个数据方便新增非叶子节点
	                },
			selectData(){//利用计算属性遍历父节点
				let result = [ { label:"Root",value: 0 } ];
				this.list.filter(item => item.func_key === "").forEach(item => {
				        result.push({ label:item.func_name,value:item.func_id })
				});
				return result;
	                },
		},
	        created(){
//	                this.$store.dispatch("func/init");
		        this.init();
                },
	        methods: {
		        ...mapActions(["init","removeFunc","addFunc","updateFunc"]),
                        remove(node){
				this.$confirm(`确认删除"${node.func_name}"节点吗` , "警告",{
                                        confirmButtonText: '确定',
                                        cancelButtonText: '取消',
                                        type: 'warning'
                                })
					.then(async () => {
//                                                await this.$store.dispatch("func/removeFunc",node.func_id);
                                                await this.removeFunc(node.func_id);
                                                this.$message({
                                                        type: 'success',
                                                        message: '删除成功!'
                                                });
                                                setTimeout(() =>  this.$router.go(0) ,100)
					})
					.catch(() => {})
			},
                        addData(parentNode){
                                this.$refs.from && this.$refs.from.resetFields();//重置表单
                                this.edit.isWord = true;
                                this.edit.isNew = true;
                                this.edit.isLeaf = parentNode.func_id !== 0 ;//判断添加叶子结点还是非叶子节点
	                        //新增初始化
                                this.edit.model.func_id = 0;
                                this.edit.model.func_name = "";
                                this.edit.model.func_key = "";
                                this.edit.model.func_fid = parentNode.func_id;

                                this.edit.isEdit = true;//打开对话框（舞台幕布）
                        },
                        edtiData(node){
                                this.$refs.from && this.$refs.from.resetFields();
                                this.edit.isWord = false;
                                this.edit.isNew = false;
                                this.edit.isLeaf = node.func_key !== "" ;//判断添加叶子结点还是非叶子节点
                                //新增初始化
                                this.edit.model.func_id = node.func_id;
                                this.edit.model.func_name = node.func_name;
                                this.edit.model.func_key = node.func_key;
                                this.edit.model.func_fid = node.func_fid;

                                this.edit.isEdit = true;//打开对话框（舞台幕布）
                        },
                         sureAdd(){
                                this.$refs.from.validate(async valid => {
                                        if(!valid) return;
                                        if(this.edit.isNew){
//                                                await this.$store.dispatch("func/addFunc",Object.assign({},this.edit.model))
	                                        await this.addFunc(Object.assign({},this.edit.model));
                                                this.$message({
                                                        type: 'success',
                                                        message: '新增成功!'
                                                });
                                        }else{
//                                                await this.$store.dispatch("func/updateFunc",Object.assign({},this.edit.model));
	                                        await this.updateFunc(Object.assign({},this.edit.model));
                                                this.$message({
                                                        type: 'success',
                                                        message: '修改成功!'
                                                });
                                        }
                                        this.edit.isEdit = false;
                                })
		        }
	        },
        };
</script>

<style lang="stylus" type="text/stylus" scoped>
	.custom-tree
		width 500px
		span.custom-tree-node
			flex 1
			display flex
			justify-content space-between
			align-items center
			span.root
				color #eb3941 !important
				font-weight bold
			span.unleaf
				color deeppink
				font-weight bold
			span.leaf
				color #1CD66C
</style>