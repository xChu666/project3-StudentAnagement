<template>
	<div>
		<el-row :gutter="20">
			<el-col v-for="item in rolesList" :key="item.role_id" :span="6">
				<el-card shadow="hover">
					<span v-text="item.role_name"></span>
					<div class="button-wrapper">
						<el-button type="text" @click="edit(item)"><i class="el-icon-edit-outline"></i></el-button>
						<el-button type="text" @click="remove(item.role_id)"><i class="el-icon-delete"></i></el-button>
						<el-button type="text" @click="beginRoleFuncConfig(item.role_id)"><i class="el-icon-s-claim"></i></el-button>
					</div>
				</el-card>
			</el-col>
			<el-col :span="6">
				<el-card class="btn-add" shadow="hover" @click.native="addName"><i class="el-icon-plus"></i></el-card>
			</el-col>
		</el-row>
		<!-- 弹框 -->
		<el-dialog :modal="false" :title="dialog.isEdit === true?'新增角色信息':'编辑角色信息'" :visible.sync="dialog.isDialog"  width="550px" >
			<el-form :model="dialog.model" :rules="rules" ref="form">
				<el-form-item prop="role_name">
					<el-input placeholder="请输入需要添加的角色"  v-model.trim="dialog.model.role_name" clearable></el-input>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				    <el-button type="primary"  v-text="dialog.isEdit === true? '确定':'保存'" @click="saveName"></el-button>
				    <el-button @click="dialog.isDialog = false">取 消</el-button>
			</span>
		</el-dialog>
		<el-drawer :visible.sync="drawer.isEdit" :showClose="false" class="custom-drawer" :modal="false" size="400px">
			<h3 slot="title">角色功能分配</h3>
				<el-tree class="custom-tree" :data="drawer.treeData" default-expand-all :expand-on-click-node="false">
				<span class="custom-tree-node" slot-scope="{ node,data }" :class="{ parent : data.func_key === '' }">
					<span>
						<i v-if="data.func_key !== '' " class="el-icon-paperclip"></i>
						<span v-text="data.func_name"></span>
					</span>
					<span class="switch-wrapper">
						<el-switch v-model="data.open" @change="switchChangeHandler(data)"></el-switch>
					</span>
				</span>
				</el-tree>

			<div class="drawer-footer">
				<el-button type="primary" @click="roleFuncConfig">确定</el-button>
				<el-button @click="drawer.isEdit=false">取消</el-button>
			</div>
		</el-drawer>
	</div>
</template>

<script type="text/ecmascript-6">
	import {createNamespacedHelpers} from "vuex";
	let {mapState:mapStateFromRole,mapActions:mapActionsFromRole} = createNamespacedHelpers("role");
        let { mapGetters:mapGettersFromFunc,mapActions:mapActionsFromFunc } = createNamespacedHelpers("func");

        export default {
                name: "Role",
                data(){
                        return {
                                dialog:{
                                        isEdit: true,//控制提示字
                                        isDialog: false,//控制弹框
                                        model: {//创建新的对象仿照数据库形式
                                                role_id: -1,
                                                role_name: "",
                                        },
                                },
                                drawer:{
                                        isEdit:false,
	                                model:{ role_id:0, role_func_ids:"" },
	                                treeData:[],//最重要的
                                },
                                //表单规则
                                rules: {
                                        role_name: [{
                                                validator:(rule, value, callback) => {
                                                        if(value.length === 0){
                                                                callback(new Error("*名字不能为空"));
                                                        }else if(value.length < 2 || value.length > 10){
                                                                callback(new Error("*名字长度2-10"));
                                                        }else if(this.rolesList.some(item => item.role_id !== this.dialog.model.role_id && item.role_name === this.dialog.model.role_name)){
                                                                callback(new Error("*该名字已存在"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur"
                                        }]
                                }
                        }
                },
	        computed:{
		        ...mapStateFromRole(["rolesList"]),
		        ...mapGettersFromFunc(["listToTree"])
	        },
                //初始渲染数据
                async created(){
                         this.isRendering();
//                        await this.init();
                         this.initFunc();
//                        this.roles = await this.$http({url: "/role/all"})
                },
                methods: {
	                ...mapActionsFromRole(["isRendering","removeRole","addRole","updateRole"]),
//	                ...mapActionsFromFunc(["init"]),
	                ...mapActionsFromFunc({initFunc:'init'}),//因为两个子仓库我没重名所以我可以不这么写
			updateTreeData(roleFuncIds){
				let result = JSON.parse(JSON.stringify(this.listToTree));//深复制一下listToTree，因为计算属性只能用不能改，不能更新数据
				result.forEach(item => {//动态开辟一个属性open，判断是否被选中
					item.open = roleFuncIds.indexOf( item.func_id ) !== -1;
					item.children && item.children.forEach(item2 => item2.open = roleFuncIds.indexOf( item2.func_id ) !== -1)
				});
                                this.drawer.treeData = result;//将更新后的数据传给treeData
			},
                        switchChangeHandler(node){
				if(node.func_key === ""){//判断是 非叶子结点
				        node.children && node.children.forEach(item => item.open = node.open )
				}else{
					  //点击的叶子要去找他爹，根据func_fid找
					let parent = this.drawer.treeData.find(item => item.func_id === node.func_fid);
                                        if(parent) parent.open = parent.children.some(item => item.open);
				}
                        },
			//点击分配角色的权限
                        async beginRoleFuncConfig(role_id){
				let roleFuncs = await this.$http({ url:"/role_function/list/" +  role_id});
				let roleFuncIds = roleFuncs.reduce((result,item) => {
					result.push(item.func_id);
					return result;
				},[]);
				console.log(roleFuncIds);
                                this.updateTreeData(roleFuncIds);

				this.drawer.model.role_func_ids = "";
				this.drawer.model.role_id = role_id;
	                        this.drawer.isEdit = true
                        },
	                //保存分配角色的权限
                        async roleFuncConfig(){
				//发送ajax前
				let func_ids = [];
				this.drawer.treeData.forEach(item => {
				        if(item.open) func_ids.push(item.func_id);
				        item.children && item.children.forEach(item2 => {
                                                if(item2.open) func_ids.push(item2.func_id);
				        })
				});
				this.drawer.model.role_func_ids = func_ids.join(",")
				//发送ajax
	                        await this.$http({
		                        method:"post",
		                        url:"role_function/config",
		                        data:this.drawer.model
	                        });
				//发送后页面相应变化
                                this.drawer.isEdit = false;
                                this.$message({ message:"角色功能分配成功",type:"success" })


                        },
                        //点击新增
                        addName(){
                                this.$refs.form && this.$refs.form.resetFields();
                                this.dialog.isEdit = true;
                                this.dialog.model.role_name = "";
                                this.dialog.isDialog = true;
                        },
                        //点击编辑
                        edit(data){
                                this.$refs.form && this.$refs.form.resetFields();
                                this.dialog.isEdit = false;
                                this.dialog.model.role_id = data.role_id;
                                this.dialog.model.role_name = data.role_name;
                                this.dialog.isDialog = true;
                        },
                        //删除
                        remove(id){
                                this.$confirm(`确认删除该角色吗`, "警告", {
                                        confirmButtonText: '确定',
                                        cancelButtonText: '取消',
                                        type: 'warning'
                                })
                                        .then(async() =>{
                                                await this.removeRole(id)
                                                this.$message({
                                                        type: 'success',
                                                        message: '删除成功!'
                                                });
                                        })
                                        .catch(() =>{ })
                        },
                        //保存或者修改
                        saveName(){
                                this.$refs.form.validate(async valid =>{
                                        if(!valid) return;
                                        if(this.dialog.isEdit){
                                                await this.addRole(Object.assign({},this.dialog.model));
                                                this.$message({
                                                        type: 'success',
                                                        message: '添加成功!'
                                                });
                                        }
                                        else{
                                                await this.updateRole(Object.assign({},this.dialog.model));
                                                this.$message({
                                                        type: 'success',
                                                        message: '修改成功!'
                                                });
                                        }
                                        this.dialog.isDialog = false;
                                })
                        }
                },
	        watch: {
			listToTree(){
			        this.drawer.isEdit = false;
			        this.updateTreeData([]);
			}
	        },
        }
</script>

<style lang="stylus" type="text/stylus" scoped>
	.el-col
		margin-bottom 30px
		.el-card
			text-align center
			padding 15%
			background #99e
			color: #fff
			font-weight bold
			font-size 24px
			cursor pointer
			position: relative
			&.btn-add
				background transparent
				border 1px dashed #99e
				color #99e
				font-weight bold
			.button-wrapper
				position absolute
				right 10px
				bottom 0
				.el-button
					font-size 20px
					color: #fff

	.custom-tree
		outline: 0
		width: 300px
		margin: 0 0 25px 50px
		overflow: auto
		height: 280px
		span.custom-tree-node
			flex: 1
			display: flex
			justify-content: space-between
			align-items: center
			i
				color: #0094ff
			&.parent
				padding-right: 50px
				color: #0094ff
	.drawer-footer
		text-align: center

</style>