<template>
	<el-container class="userClass">
		<el-header height="40px">
			<!-- 表单 -->
			<el-form :inline="true" class="displayTitle">
				<div>
					<el-form-item label="用户名查找">
						<el-input placeholder="请输入内容" v-model="getPageAll.user_name" > <i slot="prefix" class="el-input__icon el-icon-search" @click="beginUser"></i> </el-input>
					</el-form-item>
					<el-form-item label="角色查找">
						<el-select v-model="getPageAll.role_id" placeholder="请选择身份"  @change="beginUser">
							<el-option :label="'-全部-'" :value="-1"  ></el-option>
							<el-option :label="'-无角色-'" :value="0"  ></el-option>
							<el-option v-for="item in rolesList" :label="item.role_name" :value="item.role_id" :key="item.role_id" ></el-option>
						</el-select>
					</el-form-item>
				</div>
				<div>
					<el-button type="success" @click="beginAdd" icon="el-icon-plus">新增</el-button>
				</div>

			</el-form>
		</el-header>

		<el-main>
			<!-- 表格 -->
			<el-table :data="user.list" stripe style="width: 100%;height: 100%" height="100%">
				<el-table-column type="index" :index="serial" width="80" label="#" align="center"></el-table-column>
				<el-table-column prop="user_name" label="用户名" width="80"></el-table-column>
				<el-table-column prop="role_id" label="角色" width="220" align="center">
					<template slot-scope="{ row }">
						<span v-if="row.role_id !== null && rolesList.length > 0" v-text="rolesList.find(item => item.role_id === row.role_id).role_name"></span>
						<span v-else class="no_role">角色暂未分配</span>
					</template>
				</el-table-column>
				<el-table-column label="操作">
					<template slot-scope="scope">
						<el-button size="mini" type="primary" icon="el-icon-edit" @click="beginUpdate(scope.$index)">编辑</el-button>
						<el-button size="mini" type="danger" icon="el-icon-delete" @click="deleteUser(scope.$index)">删除</el-button>
						<el-popover placement="left" width="305" trigger="click">
							<p v-text="'角色分配'"></p>
							<el-select v-model="part.role_id" placeholder="请选择身份" clearable >
								<el-option  label="-取消已选角色-" :value="0"></el-option>
								<el-option v-for="item in rolesList" :label="item.role_name" :value="item.role_id" :key="item.role_id" @change="beginUser"></el-option>
							</el-select>
							<span><el-button  plain size="medium" @click="distribution(scope.$index)">分配</el-button></span>
							<el-button slot="reference" size="mini" type="success" icon="el-icon-setting" @click="beginDistribution(scope.row)">角色分配</el-button>
						</el-popover>
					</template>
				</el-table-column>
			</el-table>
		</el-main>
		<el-footer height="40px">
			<el-pagination background
			               layout="prev, pager, next,jumper,->,sizes,total"
			               :total="user.total"
			               @current-change="getPage"
			               :page-size.sync="getPageAll.pageSize"
			               :page-sizes="[5,7,9,11,13]"
			               @size-change="getSize"
			></el-pagination>
		</el-footer>
		<!-- 弹窗 -->
		<el-dialog :modal="false" :title="isEdit === true?'新增用户信息':'编辑用户信息'" :visible.sync="isDialog"  width="400px" >
			<el-form :model="model" ref="userForm" :rules="rules" label-width="70px" @validate="formValidateHandler">
				<el-form-item label="用户名" prop="user_name">
					<el-input placeholder="请输入用户名字"  v-model.trim="model.user_name" clearable :disabled="!isEdit"></el-input>
				</el-form-item>
				<el-form-item label="密码" prop="user_pwd">
					<el-input placeholder="请输入用户密码"  v-model.trim="model.user_pwd" clearable></el-input>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				    <el-button type="primary"  v-text="isEdit === true? '确定':'保存'" @click="saveUser"></el-button>
				    <el-button @click="isDialog = false">取 消</el-button>
			</span>
		</el-dialog>
	</el-container>
</template>

<script type="text/ecmascript-6">
	import ElForm from "../../../node_modules/element-ui/packages/form/src/form.vue";
        import {createNamespacedHelpers} from "vuex";
        let {mapState,mapActions} = createNamespacedHelpers("role");
        export  default {
                name: "User",
		data(){
			return{
                                isDialog:false,//弹框开关
                                isEdit:true,//编辑|新增状态
				xIdentity:"",//搜索下拉用
                                idvip:"",//选择身份专用
				getPageAll:{//初始渲染传的数据
                                        user_name:"",//查找渲染用的用户名字
                                        role_id:-1,//查找角色用的角色名字
                                        begin:0,
                                        pageSize:5,
                                },
				user:{
                                        list:[],//遍历的数组
					total:0,//总数
				},
                                userNameValidateResult:'undefined',
				model: { user_name: "",user_pwd: "", role_id: null },//保存时的data
                                part:{user_name:"", role_id:null},//分配角色的data
				rules:{//表单验证规则
                                        user_name:[{
	                                        validator:async (rule,value,callback) => {
	                                                if(!this.isEdit)
                                                                callback();
	                                                else if( !/^[a-zA-Z][a-zA-Z0-9]{2,19}$/.test(value))
	                                                        callback(new Error("*用户名长度3-20，且只能包含字母或数字，不能以数字开头"))
	                                                else if( await this.$http({method:"post",url:"/user/valid_name",data :{ user_name:value }}))
	                                                        callback(new Error("*该用户名已存在"))
	                                                else
	                                                        callback();

	                                        },
	                                        trigger:"blur"
                                        }],
                                        user_pwd:[{
                                                validator:(rule,value,callback) => {
                                                        if(value.length === 0 ){
                                                                callback(new Error("*密码不能为空"))
                                                        }else if(value.length < 3 || value.length>20){
                                                                callback(new Error("*用户名长度3-20"))
                                                        }else{
                                                                callback();
                                                        }
                                                }
                                        }]
				}
			}
	        },
	        //计算属性获取role_id对应的角色
                computed:{
	                ...mapState(["rolesList"]),
//                       changeList(){
//                             let list = [].concat(this.user.list);
//                             list.forEach(item => {
//	                             this.rolesList.forEach(findId => {
//                                             if(item.role_id === null) item.role_id = "角色暂未分配";
//	                                     if(findId.role_id === item.role_id)  item.role_id = findId.role_name;
//	                             });
//                             });
//                             return list
//                       }
                },
	        methods:{
                        ...mapActions(["isRendering"]),
		        //根据身份查找
//                        Identity(){
////                                this.getPageAll.role_id = this.xIdentity || null;
//                                this.beginUser();
//                        },
		        //自定义排序编号
                        serial(index){
                                return index + 1
                        },
		        //渲染用户数据
                        async beginUser(){
                                let jieshou = await this.$http({method:"post",  url:"/user/list", data:this.getPageAll  });
                                this.user = jieshou;
                                console.log(jieshou)
		        },
		        //改变页数
                        getPage(page){
                                this.getPageAll.begin = (page - 1) * this.getPageAll.pageSize;
                                this.beginUser();
                        },
		        //改变条数
                        getSize(){
                                this.getPageAll.begin = 0;
                                this.beginUser();
                        },
//		        //点击新增
		        beginAdd(){
                                this.$refs.userForm && this.$refs.userForm.resetFields();
                                this.isEdit=true;
                                this.model.user_name = "";
                                this.model.user_pwd = "";
                                this.isDialog=true;
		        },
		        //点击修改
		        beginUpdate(index){
                                this.$refs.userForm && this.$refs.userForm.resetFields();
                                this.isEdit = false;
                                this.model.user_name = this.user.list[index].user_name;
				this.model.user_pwd = this.user.list[index].user_pwd;
                                this.isDialog=true;
		        },
		        //监听formValidateHandler变化
                        formValidateHandler(prop,valid,message){
		                      if(prop === "user_name") this.userNameValidateResult = valid;
                        },
		        //确认添加||保存
		        async saveUser(){
                                if(this.isEdit){
                                        if(this.userNameValidateResult === false) return;
                                        if(typeof this.userNameValidateResult === "undefined"){
                                                await new Promise(resolve => this.$refs.userForm.validateField("user_name",message => {
                                                        if(message === "") resolve();
                                                }));
                                        }
                                }
                                await  new Promise(resolve => this.$refs.userForm.validateField("user_pwd",message => {
                                        if(message === "") resolve();
                                }));
                                //代码执行到这里，说明用户名和密码都通过了验证，可以执行后面真正的新增与修改了
//		                this.$refs.userForm.validate(async valid => {
//		                        if(!valid) return;
                                        if(this.isEdit){
                                                await this.$http({ url:"/user/add",method: "post",data:this.model });
                                                this.user.list.push(Object.assign({},this.model));
                                                this.$message({
                                                        type: 'success',
                                                        message: '添加成功!'
                                                });
                                        }else{
                                                await this.$http({ url:"/user/change_pwd",method:"post",data:this.model });
                                                let i = this.user.list.findIndex(item => item.user_name === this.model.user_name);
                                                this.user.list.splice(i,1,Object.assign({},this.model));
                                                this.$message({
                                                        type:"success",
                                                        message:"修改成功"
                                                })
                                        };
                                        this.isDialog=false;
//		                })
		        },
//		        //点击删除
		        deleteUser(index){
                                let user_name = this.user.list[index].user_name;
		                this.$confirm("确认删除" + user_name + "吗？","警告",{
                                        confirmButtonText: '确定',
                                        cancelButtonText: '取消',
                                        type: 'warning'
		                })
			                .then(async () => {
                                                await this.$http({ url:"/user/remove/" + user_name,method:"post" });
                                                this.user.list.splice(index,1);
                                                this.$message({
                                                        type:"success",
                                                        message: user_name + "删除成功"
                                                })
			                })
		        },
		        //点击角色分配时候
			beginDistribution(row){
		                console.log(row);
				this.part.user_name = row.user_name;
                                this.part.role_id = row.role_id
			},
//		        //分配角色
		        async distribution(index){
		                console.log(index)
//			        this.part.user_name = this.user.list[index].user_name;//ajax需要的名字=当前编辑的名字
//                                this.part.role_id = this.rolesList[this.rolesList.findIndex(item => item.role_name === this.part.role_id)].role_id || 0;
                                //ajax需要的id是role里面找到role_name和选中的名字相同的那一个的下标，的id
				await this.$http({ url:"/user/config_role" ,method:"post",data:this.part});
                                this.$message({
                                        type:"success",
                                        message: this.part.user_name + "角色分配成功"
                                });
                                let i = this.user.list.findIndex(item => item.user_name === this.part.user_name);
                                this.user.list.splice(i,1,Object.assign({},this.part));
				console.log(this.part);
		        }
	        },
                watch: {
                        isDialog( newValue ){
                                if( !newValue ) delete this.userNameValidateResult;
                        }
                },

                async created(){
                        this.isRendering();//通知发送ajax请求
		        this.beginUser();
//                        await this.$store.dispatch("role/isRendering")

	        }
	}
</script>

<style lang="stylus" type="text/stylus" scoped>
	.el-container
		position absolute
		left 0
		top 0
		width 100%
		height 100%
	.main
		span.no_role
			color: #f00

</style>