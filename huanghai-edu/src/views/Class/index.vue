<template>
	<el-container>
		<el-header>
			<el-form :inline="true" class="displayTitle">
				<div>
					<el-form-item label="班级名称">
						<el-input popover="请输入搜索内容" v-model="getList.cls_name"><i slot="prefix" class="el-input__icon el-icon-search" @click="getSize"></i></el-input>
					</el-form-item>
					<el-form-item label="班级专业">
						<el-select v-model="getList.cls_dic_id_major" @change="getSize">
							<el-option :value="0" label="- 全部 -"></el-option>
							<el-option v-for="item in getGroupByKey('class_major')" :label="item.dic_name" :value="item.dic_id" :key="item.dic_id"></el-option>
						</el-select>
					</el-form-item>
					<el-form-item label="班级状态">
						<el-select v-model="getList.cls_status"  @change="getSize">
							<el-option v-for="item in remarkList" :key="item.cls_status" :value="item.cls_status" :label="item.remarkName"></el-option>
						</el-select>
					</el-form-item>
				</div>
				<div>
					<el-form-item>
						<el-button icon="el-icon-plus" type="success" @click="beginAdd">新增</el-button>
					</el-form-item>
				</div>
			</el-form>
		</el-header>
		<el-main>
			<el-table :data="getClassAllMax" border height="100%">
				<el-table-column label="#" type="index"  width="50" align="center"></el-table-column>
				<el-table-column label="班级名称"  width="100" prop="cls_name"></el-table-column>
				<el-table-column label="班级专业"  width="100" prop="cls_dic_id_major">
					<template slot-scope="{ row }">
						<span v-text=" row.cls_dic_id_major ? getGroupByKey('class_major').find(item => item.dic_id === row.cls_dic_id_major).dic_name : null"></span>
					</template>
				</el-table-column>
				<el-table-column label="教学老师"  width="100" prop="cls_stf_id_teacher_name">
					<template slot-scope="{ row }">
						<span v-text=" staffListTeacher.length>0 && staffListTeacher.find(item => item.stf_id === row.cls_stf_id_teacher).stf_name"></span>
					</template>
				</el-table-column>
				<el-table-column label="教务老师"  width="100" prop="cls_stf_id_admin_name">
					<template slot-scope="{ row }">
						<span v-text="staffListAdmin.length>0 && staffListAdmin.find(item => item.stf_id === row.cls_stf_id_admin).stf_name"></span>
					</template>
				</el-table-column>
				<el-table-column label="就业老师"  width="100" prop="cls_stf_id_job_name">
					<template slot-scope="{ row }">
					<span v-text=" staffListJob.length>0 && staffListJob.find(item => item.stf_id === row.cls_stf_id_job).stf_name"></span>
				</template>
				</el-table-column>
				<el-table-column label="班级"  width="100">
					<template slot-scope="{ row }">
						<span v-text="classRoomList.find(item => item.clsr_id === row.cls_clsr_id) && classRoomList.find(item => item.clsr_id === row.cls_clsr_id).clsr_name"></span>
					</template>
				</el-table-column>
				<el-table-column label="开课时间"  width="100" prop="cls_begin"></el-table-column>
				<el-table-column label="结课时间"  width="100" prop="cls_end"></el-table-column>
				<el-table-column label="班级状态"  width="100">
					<template slot-scope="{ row }">
						<span v-text="remarkList.find(item => item.cls_status === row.cls_status).remarkName" :class="{ start:row.cls_status === 1 ,end: row.cls_status === 3 , ing:row.cls_status === 2}"></span>
					</template>
				</el-table-column>
				<el-table-column label="备注">
					<template slot-scope="{ row }">
						<span v-if="row.cls_remark !== ''" v-text="row.cls_remark"></span>
						<span v-else class="end">暂无相关班级备注</span>
					</template>
				</el-table-column>
				<el-table-column label="操作"  width="200">
					<template slot-scope="{row}">
						<el-button size="mini" type="primary" icon="el-icon-edit" @click="beginEdit(row)">修改</el-button>
						<el-button size="mini" type="danger"  v-show="row.cls_status === 1" @click="endBeginClass(row)">结课</el-button>
						<el-button size="mini" type="success"  v-show="row.cls_status === 2" @click="startBeginClass(row)">开课</el-button>
					</template>
				</el-table-column>
			</el-table>
		</el-main>
		<el-footer height="40px">
			<el-pagination background
			               layout="prev, pager, next,jumper,->,sizes,total"
			               :total="classList.total"
			               @current-change="getPage"
			               :page-size.sync="getList.pageSize"
			               :page-sizes="[5,7,9,11,13]"
			               @size-change="getSize"
			></el-pagination>
		</el-footer>
		<el-dialog :modal="false" :title="edit.isWord === true? '新增班级':'编辑班级'" :visible.sync="edit.isEdit"  width="550px" >
			<!-- 表单中内容 -->
			<el-form :model="edit.model" :inline="true" label-width="80px" :disabled="edit.model.cls_status===3" ref="bigForm" :rules="rules">
				<el-form-item label="班级名称" prop="cls_name">
					<el-input placeholder="请输入班级名字" clearable v-model="edit.model.cls_name"></el-input>
				</el-form-item>
				<el-form-item label="班级专业" prop="cls_dic_id_major">
					<el-select v-model="edit.model.cls_dic_id_major">
						<el-option v-for="item in getGroupByKey('class_major')" :label="item.dic_name" :value="item.dic_id" :key="item.dic_id"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="教室"  v-show="edit.model.cls_status===1" :disabled="edit.model.cls_clsr_id===null">
					<el-select v-model="edit.model.cls_clsr_id">
						<el-option v-for="item in classRoomList" :label="item.clsr_name" :key="item.clsr_id" :value="item.clsr_id" :disabled="item.clsr_occupy === 1"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="教学老师" prop="cls_stf_id_teacher">
					<el-select v-model="edit.model.cls_stf_id_teacher">
						<el-option v-for="item in staffListTeacher" :label="item.stf_name" :key="item.stf_id" :value="item.stf_id" :disabled="!item.stf_invalid"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="教务老师" prop="cls_stf_id_admin">
					<el-select v-model="edit.model.cls_stf_id_admin">
						<el-option v-for="item in staffListAdmin" :label="item.stf_name" :key="item.stf_id" :value="item.stf_id" :disabled="!item.stf_invalid"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="就业老师" prop="cls_stf_id_job">
					<el-select v-model="edit.model.cls_stf_id_job">
						<el-option v-for="item in staffListJob" :label="item.stf_name" :key="item.stf_id" :value="item.stf_id" :disabled="!item.stf_invalid"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="班级备注">
					<el-input  type="textarea" :rows="2" placeholder="请输入内容" v-model="edit.model.cls_remark"></el-input>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button type="primary" @click="saveClass" v-text="edit.isWord === true? '确定':'保存'" v-show="edit.model.cls_status!==3"></el-button>
				<el-button @click="edit.isEdit = false">取 消</el-button>
			</span>
		</el-dialog>
		<!--开课选班级-->
		<el-dialog :modal="false" title="选择班级" :visible.sync="edit.isClass"  width="550px">
			<el-form :model="edit.model" :inline="true" label-width="80px" ref="simForm" :rules="rules">
				<el-form-item label="班级" prop="cls_clsr_id">
					<el-select v-model="edit.model.cls_clsr_id">
						<el-option v-for="item in classRoomList" :label="item.clsr_name" :key="item.clsr_id" :value="item.clsr_id" :disabled="item.clsr_occupy === 1"></el-option>
					</el-select>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button type="primary" @click="startClass" v-text="'确定'" ></el-button>
				<el-button @click="edit.isClass = false">取 消</el-button>
			</span>
		</el-dialog>
	</el-container>
</template>

<script type="text/ecmascript-6">
	import {createNamespacedHelpers} from "vuex";
        import ElDialog from "../../../node_modules/element-ui/packages/dialog/src/component.vue";
	let { mapState:mapStateFromClasss ,mapActions:mapActionsFromClasss,mapGetters:mapGettersFromClass} = createNamespacedHelpers("classs");
	let { mapState:mapStateFromDictionary,mapGetters:mapGettersFromDictionary } = createNamespacedHelpers("dictionary");
	let { mapState:mapStateFromClassRoom,mapActions:mapActionsFromClassRoom } = createNamespacedHelpers("classroom");
        let { mapState:mapStateFromStaff,mapActions:mapActionsFromStaff } = createNamespacedHelpers("staff");
        export default {
                components: {ElDialog},
                name: "Class",
	        data(){
                        return {
//                                isDialog:false,//验证重名
//                                userNameValidateResult:'undefined',
				getList:{
                                        cls_name:"",
					cls_dic_id_major:0,
					cls_status:0,//是否开班
					begin:0,
					pageSize:5
				},
	                        edit:{
                                        isWord:true,
                                        isEdit:false,
		                        isClass:false,
				        model:{
                                                cls_id:0,
                                                cls_name:"",
					        cls_dic_id_major:null,
					        cls_clsr_id:null,
					        cls_stf_id_teacher:null,
					        cls_stf_id_admin:null,
					        cls_stf_id_job:null,
					        cls_begin:null,
					        cls_end:null,
					        cls_remark:'',
                                                cls_status : 2,
                                                oldClassId:null,
				        },
	                        },
                                staffListTeacher: [],//教学
                                staffListAdmin: [],//教务
                                staffListJob: [],//就业
                                //开班状态
                                remarkList:[//开班状态
	                                { cls_status : 0, remarkName:"全部"},
	                                { cls_status : 1, remarkName:"开课中"},
	                                { cls_status : 2, remarkName:"未开课"},
	                                { cls_status : 3, remarkName:"已结课"}
                                ],
	                        rules:{
                                        cls_name: [{
                                                validator: async  (rule, value, callback) => {
                                                        if(value.length === 0){
                                                                callback(new Error("*班级名称不能为空"));
                                                        }else if( !/^[0-9][a-zA-Z0-9]{2,19}$/.test(value)){
                                                                callback( new Error("*班级名称长度3-20，且只能包含字母数字，必须以数字开头") );
                                                        }
                                                        else if( this.edit.isWord && await this.$http({method: "post", url: "/class/valid_name", data: {cls_name: value}}) ){
                                                                callback(new Error("*用户名已存在"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur"
                                        }],
                                        cls_dic_id_major: [{
                                                validator:(rule, value, callback) => {
                                                        if(value === null&&this.edit.isWord){
                                                                callback(new Error("*请选择相关专业"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur"
                                        }],
                                        cls_stf_id_teacher: [{
                                                validator:(rule, value, callback) => {
                                                        if(value === null&&this.edit.isWord){
                                                                callback(new Error("*请选择教学老师"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur"
                                        }],
                                        cls_stf_id_admin: [{
                                                validator:(rule, value, callback) => {
                                                        if(value === null&&this.edit.isWord){
                                                                callback(new Error("*请选择教务老师"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur"
                                        }],
                                        cls_stf_id_job: [{
                                                validator:(rule, value, callback) => {
                                                        if(value === null&&this.edit.isWord){
                                                                callback(new Error("*请选择就业老师"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur"
                                        }],
                                        cls_clsr_id:[{
                                                validator:(rule, value, callback) => {
                                                        if(value === null){
                                                                callback(new Error("*请选择班级"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur"
                                        }],
	                        }
		        }
	        },
		computed:{
			...mapStateFromClasss(["classAll","classList"]),//班级
			...mapGettersFromClass(["getClassAllMax"]),
			...mapStateFromClassRoom(["classRoomList"]),//教室
                        ...mapStateFromDictionary(["dictionary"]),//字典
			...mapGettersFromDictionary(["getGroupByKey"]),//字典返回方法
			...mapStateFromStaff(["staffList"]),//人员信息
		},
	        methods:{
		        ...mapActionsFromClasss(['isClassAll',"isClassList","beginAddClass","beginEditClass"]),
		        ...mapActionsFromClassRoom(["isUsedClass"]),
		        ...mapActionsFromStaff(["isGetStaff"]),
                        getPage(page){//改变页数
                                this.getList.begin = (page - 1) * this.getList.pageSize;
                                this.isClassList(Object.assign({},this.getList));
                        },
                        getSize(){//改变条数
                                this.getList.begin = 0;
                                this.isClassList(Object.assign({},this.getList));
                        },
		        beginAdd(){//准备添加
                                this.$refs.bigForm && this.$refs.bigForm.resetFields();
		                this.edit.isWord = true;
                                this.edit.model.cls_id = 0;
                                this.edit.model.cls_name="";
                                this.edit.model.cls_dic_id_major=null;
                                this.edit.model.cls_clsr_id=null;
                                this.edit.model.cls_stf_id_teacher=null;
                                this.edit.model.cls_stf_id_admin=null;
                                this.edit.model.cls_stf_id_job=null;
                                this.edit.model.cls_begin=null;
                                this.edit.model.cls_end=null;
                                this.edit.model.cls_remark="";
                                this.edit.model.cls_status = 0;
//                                this.isDialog=true;
                                this.edit.isEdit=true;
		        },
                        beginEdit(node){//准备编辑
                                this.$refs.bigForm && this.$refs.bigForm.resetFields();
                                this.edit.model.oldClassId = node.cls_clsr_id;
                                this.edit.isWord = false;
                                this.edit.model.cls_name=node.cls_name;
                                this.edit.model.cls_id = node.cls_id;
                                this.edit.model.cls_dic_id_major=node.cls_dic_id_major;
                                this.edit.model.cls_clsr_id=node.cls_clsr_id;
                                this.edit.model.cls_stf_id_teacher=node.cls_stf_id_teacher;
                                this.edit.model.cls_stf_id_admin=node.cls_stf_id_admin;
                                this.edit.model.cls_stf_id_job=node.cls_stf_id_job;
                                this.edit.model.cls_begin=node.cls_begin;
                                this.edit.model.cls_end=node.cls_end;
                                this.edit.model.cls_remark=node.cls_remark;
                                this.edit.model.cls_status = node.cls_status;
//                                this.isDialog=true;
                                this.edit.isEdit=true;
                                console.log(node)
                        },
                        //监听formValidateHandler变化
//                        formValidateHandler(prop,valid,message){
//                                if(prop === "cls_name") this.userNameValidateResult = valid;
//                        },
		        async saveClass(){//保存
//                                if(this.edit.isEdit){
//                                        if(this.userNameValidateResult === false) return;
//                                        if(typeof this.userNameValidateResult === "undefined"){
//                                                await new Promise(resolve => this.$refs.bigForm.validateField("cls_name",message => {
//                                                        if(message === "") resolve();
//                                                }));
//                                        }
//                                }
			        this.$refs.bigForm.validate(async valid =>{
			                if(!valid) return;
                                        if(this.edit.isWord){//增
                                                await this.beginAddClass(Object.assign({},this.edit.model))
                                                this.$message({ message:"班级添加成功", type:"success" });
                                        }else{//改
                                                if(this.edit.model.oldClassId) this.classRoomList.find(item => item.clsr_id === this.edit.model.oldClassId).clsr_occupy = 0;//让原来的教室释放
                                                await this.beginEditClass(Object.assign({},this.edit.model));
                                                if(this.edit.model.oldClassId) this.classRoomList.find(item => item.clsr_id === this.edit.model.cls_clsr_id).clsr_occupy = 1;//让新的教室使用
                                                this.$message({ message:"班级信息修改成功", type:"success" });
                                        }
                                        this.edit.isEdit = false;
			        });
//                                this.isDialog=false;
		        },
                        startBeginClass(node){//准备开课
                                this.edit.model.cls_id = node.cls_id;
                                this.edit.model.cls_clsr_id=node.cls_clsr_id;
                                this.edit.isClass = true;
                        },
                        startClass(){//开课
                                this.$refs.simForm.validate(async valid =>{
                                        if(!valid) return;
                                        let beginTime = await this.$http({ url:"/class/begin",method:"post",data:this.edit.model });
                                        this.classList.list.find(item => item.cls_id === this.edit.model.cls_id).cls_begin = beginTime;
                                        this.classList.list.find(item => item.cls_id === this.edit.model.cls_id).cls_clsr_id = this.edit.model.cls_clsr_id;
                                        this.classRoomList.find(item => item.clsr_id === this.edit.model.cls_clsr_id).clsr_occupy = 1;
                                        this.$message({ message:"教室已分配，开班成功" ,type:"success"});
                                        this.edit.isClass = false;
                                });
                        },
		        endBeginClass(node){//准备结课
                                this.$confirm("确认该班级结课？","警告",{
                                        confirmButtonText: '确定',
                                        cancelButtonText: '取消',
                                        type: 'warning'
                                })
	                                .then( async () => {
                                                let endTime = await this.$http({ url:"/class/end",method:"post",data:node });
                                                node.cls_end = endTime;
                                                let i = this.classList.list.findIndex(item => item.cls_id === node.cls_id);
                                                console.log(i);
                                                this.classList.list.splice(i,1,node);
                                                this.classRoomList.find(item => item.clsr_id === node.cls_clsr_id).clsr_occupy = 0;
                                                this.$message({ message:"该班级已结课" ,type:"success"});
	                                } )
                                        .catch(()=>{});
                        },
	        },
//                watch: {
//                        isDialog( newValue ){
//                                if( !newValue ) delete this.userNameValidateResult;
//                        }
//                },
	        async created(){
                        this.$http({ url:"/staff/listbycategory/4" }).then(list => this.staffListTeacher = list);
                        this.$http({ url:"/staff/listbycategory/5" }).then(list => this.staffListAdmin = list);
                        this.$http({ url:"/staff/listbycategory/6" }).then(list => this.staffListJob = list);
		        this.isUsedClass();
			this.isClassList(Object.assign({},this.getList));
                        await this.isClassAll();
                        console.log(this.classRoomList);
//                        console.log(this.getGroupByKey('class_major'));
//                        console.log(this.classRoomList);
//                        console.log(this.staffList);
//		            console.log(this.staffListTeacher);
//                        console.log(this.staffListAdmin);
//                        console.log(this.staffListJob);
	        },
        }
</script>

<style lang="stylus" type="text/stylus" scoped>
	.el-header
		width 1475px
	.el-container
		position absolute
		left 0
		top 0
		width 100%
		height 100%
	.el-main
		.start
			color: #f00
		.ing
			color: #0f0
		.end
			color:#999

</style>