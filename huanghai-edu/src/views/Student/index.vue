<template>
	<el-container>
		<el-header>
			<el-form :inline="true" class="displayTitle">
				<div>
					<el-form-item label="学生名称">
						<el-input popover="请输入搜索内容" v-model="getStudentList.stu_name"><i slot="prefix" class="el-input__icon el-icon-search" @click="getSize"></i></el-input>
					</el-form-item>
					<el-form-item label="所在班级">
						<el-select v-model="getStudentList.stu_cls_id" @change="getSize">
							<el-option :value="0" label="- 全部班级 -"></el-option>
							<el-option :value="null" label="- 无班级 -"></el-option>
							<el-option v-for="item in classAll" :label="item.cls_name" :value="item.cls_id" :key="item.cls_id"></el-option>
						</el-select>
					</el-form-item>
					<el-form-item label="学生学历">
						<el-select v-model="getStudentList.stu_qualification"  @change="getSize">
							<el-option :value="null" label="- 全部学历 -"></el-option>
							<el-option v-for="item in getGroupByKey('qualification')" :label="item.dic_name" :value="item.dic_id" :key="item.dic_id"></el-option>
						</el-select>
					</el-form-item>
				</div>
				<div>
					<el-form-item>
						<el-button icon="el-icon-plus" type="success" @click="beginAdd">新增</el-button>
						<el-button icon="el-icon-share" type="primary" @click="beginMoreClass">批量分班</el-button>
						<el-button icon="el-icon-download" type="danger" @click="">导出学生信息</el-button>
					</el-form-item>
				</div>
			</el-form>
		</el-header>
		<el-main>
			<el-table :data="studentAll.list"border height="320"  @selection-change="pushStudentAll">
				<el-table-column label="#" type="index"  width="40" align="center" fixed></el-table-column>
				<el-table-column type="selection" width="50" fixed align="center" show-overflow-tooltip></el-table-column>
				<el-table-column label="学生姓名" prop="stu_name" width="80" fixed></el-table-column>
				<el-table-column label="班级"  width="100">
					<template  slot-scope="{row}">
						<span v-text="row.stu_cls_id&&classAll.length>0 ? classAll.find(item => item.cls_id ===  row.stu_cls_id).cls_name : null" v-if="row.stu_cls_id !== null "></span>
						<span class="gory" v-else>无班级</span>
					</template>
				</el-table-column>
				<el-table-column label="存档照片" align="center">
					<template slot-scope="{ row }">
						<el-popover
							placement="right"
							trigger="click">
							<el-image
								style="width: 200px; height: 250px"
								:src="row.stu_avatar? row.stu_avatar:'/images/student/666666.jpg'"
								></el-image>
							<span class="blue" slot="reference">预览</span>
						</el-popover>
					</template>
				</el-table-column>
				<el-table-column label="性别" width="50">
					<template slot-scope="{ row }">
						<span v-text=" row.stu_sex === 1?'男':'女' "></span>
					</template>
				</el-table-column>
				<el-table-column label="联系电话" prop="stu_phone" width="130"></el-table-column>
				<el-table-column label="联系电话(备用)" prop="stu_phone2" width="150"></el-table-column>
				<el-table-column label="出生日期" prop="stu_born" width="100"></el-table-column>
				<el-table-column label="学历" width="100">
					<template  slot-scope="{row}">
						<span v-text="row.stu_qualification ? getGroupByKey('qualification').find(item => item.dic_id ===  row.stu_qualification).dic_name : null"></span>
					</template>
				</el-table-column>
				<el-table-column label="毕业院校" prop="stu_school"width="150"></el-table-column>
				<el-table-column label="院校专业" prop="stu_major"width="150"></el-table-column>
				<el-table-column label="家庭住址" prop="stu_address"width="200"></el-table-column>
				<el-table-column label="备注" prop="stu_remark"width="250">
					<template slot-scope="{ row }">
						<span v-text="row.stu_remark" v-if="row.stu_remark !== ''"></span>
						<span class="gory" v-else>暂无相关备注....</span>
					</template>
				</el-table-column>
				<el-table-column label="操作"  width="400"  fixed="right">
					<template slot-scope="{row}">
						<el-button size="mini" type="primary" icon="el-icon-share" @click="beginStudentGrouping(row)">分班</el-button>
						<el-button size="mini" type="danger" icon="el-icon-picture-outline" @click="beginAvatar(row)">照片存档</el-button>
						<el-button size="mini" type="success" icon="el-icon-edit" @click="beginEdit(row)">编辑</el-button>
						<el-button size="mini" type="warning" icon="el-icon-delete" @click="">删除</el-button>
					</template>
				</el-table-column>
			</el-table>
		</el-main>
		<el-footer height="40px">
			<el-pagination background
			               layout="prev, pager, next,jumper,->,sizes,total"
			               :total="studentAll.total"
			               @current-change="getPage"
			               :page-size.sync="getStudentList.pageSize"
			               :page-sizes="[5,7,9,11,13]"
			               @size-change="getSize"
			></el-pagination>
		</el-footer>
		<!--上传头像弹框-->
		<el-dialog :modal="false" title="选择照片" :visible.sync="edit.isStudent"  width="600px">
			<div class="picClass">
				<div v-show="this.edit.model.stu_avatar !== null">
					<!--<span>旧头像</span>-->
					<el-image
						style="width: 148px; height: 148px"
						:src="this.edit.model.stu_avatar ? this.edit.model.stu_avatar:''"
					></el-image>
				</div>
				<div>
					<!--<span>新头像</span>-->
					<el-upload
						ref="upload"
						list-type="picture-card"
						accept=".jpg,.png"
						action="/student/avatarupload"
						:headers="uploadHeaders"
						name="avatar"
						:before-upload="beforeAvatarUpload"
						:on-success="avatarUploadSuccess"
						:on-remove="avatarRemove">
						<i class="el-icon-plus"></i>
						<P slot="tip">提示：只能上传jpg或png文件，且大小不超过2M</P>
					</el-upload>
					<el-button :disabled="upload.model.stu_avatar_new === null" type="primary" @click="saveAvatar">确定</el-button>
				</div>
			</div>
		</el-dialog>
		<!--新增弹框-->
		<el-dialog :modal="false" :title="`班级维护--${ edit.isEdit?'新增':'修改' }`" :visible.sync="edit.isDialog" width="550px">
			<el-form :model="edit.model" label-width="120px" :rules="rules" ref="ruleForm">
				<el-form-item label="学生姓名" prop="stu_name">
					<el-input placeholder="请输入学生姓名" v-model="edit.model.stu_name"></el-input>
				</el-form-item>
				<el-form-item label="性别">
						<el-radio :label="1" v-model="edit.model.stu_sex">男</el-radio>
						<el-radio :label="2" v-model="edit.model.stu_sex">女</el-radio>
				</el-form-item>
				<el-form-item label="联系电话" prop="stu_phone">
					<el-input placeholder="请输入手机号" v-model="edit.model.stu_phone" maxlength="11" show-word-limit></el-input>
				</el-form-item>
				<el-form-item label="备用电话" prop="stu_phone2">
					<el-input placeholder="请输入备用手机号" v-model="edit.model.stu_phone2">
						<template slot="append">例如：028-88888888</template>
					</el-input>
				</el-form-item>
				<el-form-item label="出生日期" prop="stu_born">
					<el-date-picker type="date" placeholder="请选择日期" v-model="edit.model.stu_born" style="width: 100%;" value-format="yyyy-MM-dd"></el-date-picker>
				</el-form-item>
				<el-form-item label="学历" prop="stu_qualification">
					<el-select v-model="edit.model.stu_qualification" placeholder="请选择学历">
						<el-option v-for="item in getGroupByKey('qualification')" :key="item.dic_id" :value="item.dic_id" :label="item.dic_name"></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="在读/毕业院校">
					<el-input placeholder="请输入在读/毕业的院校(选填)" v-model="edit.model.stu_school"></el-input>
				</el-form-item>
				<el-form-item label="在校学习专业">
					<el-input placeholder="请输入在校学习专业(选填)" v-model="edit.model.stu_major"></el-input>
				</el-form-item>
				<el-form-item label="家庭住址" prop="stu_address">
					<el-input placeholder="请输入家庭住址" v-model="edit.model.stu_address"></el-input>
				</el-form-item>
				<el-form-item label="学生备注">
					<el-input placeholder="请输入学生备注..." type="textarea" v-model="edit.model.stu_remark"></el-input>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
			    <el-button type="primary" @click="saveStudent" v-text="edit.isEdit === true? '确定':'保存'"></el-button>
			    <el-button @click="edit.isDialog = false">取 消</el-button>
			  </span>
		</el-dialog>
		<!--分班弹框-->
		<el-dialog :modal="false" title="选择班级" :visible.sync="edit.isGrouping"  width="400px">
			<el-select v-model="edit.model.stu_cls_id">
				<el-option v-for="item in classAll" :label="item.cls_name" :value="item.cls_id" :key="item.cls_id" :disabled="item.cls_begin !== null && item.cls_end === null"></el-option>
			</el-select>
			<span slot="footer" class="dialog-footer">
			    <el-button type="primary" @click="studentGrouping" v-text="'确定'"></el-button>
			    <el-button @click="edit.isGrouping = false">取 消</el-button>
			  </span>
		</el-dialog>
	</el-container>
</template>

<script type="text/ecmascript-6">
	import {createNamespacedHelpers} from "vuex";
	let { mapState:mapStateFromDictionary,mapGetters:mapGettersFromDictionary } =createNamespacedHelpers("dictionary");
        let { mapState:mapStateFromClasss ,mapActions:mapActionsFromClasss,mapGetters:mapGettersFromClass} = createNamespacedHelpers("classs");
        export default {
                name: "Student",
		data(){
                        return {
                                uploadHeaders:{ "Authorization":sessionStorage.getItem("token") },
	                        upload:{//上传数据
                                        isUpload:false,
		                        model:{
                                                stu_id:0,
			                        stu_avatar_old:null,
			                        stu_avatar_new:null,
		                        }
	                        },
	                        getStudentList:{//渲染数据用
                                        stu_name:null,
		                        stu_cls_id:0,
		                        stu_qualification:null,
		                        begin:0,
		                        pageSize:5,
	                        },
	                        studentAll:{//数据库中的数据
                                        list:[],
		                        total:0,
	                        },
	                        openClass:[],
	                        edit:{//构造传的数据
                                        isStudent:false,//上传头像弹框
		                        isEdit:true,//是新增还是编辑
		                        isDialog:false,//新增弹框
		                        isGrouping:false,//分班弹框
		                        isPiliang:true,
		                        model:{
                                                stu_name:null,
			                        stu_avatar:null,
			                        stu_cls_id:null,
			                        stu_sex:1,
			                        stu_phone:null,
			                        stu_phone2:null,
			                        stu_born:null,
			                        stu_qualification:null,
			                        stu_school:"",
			                        stu_major:"",
			                        stu_address:null,
			                        stu_remark:"",
			                        stu_id:null
		                        },
                                },
                                rules:{
                                        stu_phone: [{
                                                validator:(rule, value, callback) => {
                                                        if(value===null){
                                                                callback(new Error("*手机号不能为空"));
                                                        }else if(!/^1\d{10}$/.test(value)){
                                                                callback(new Error("*手机号格式错误"));
                                                        }else if(this.edit.isEdit && this.studentAll.list.length>0 && this.studentAll.list.some(item => item.stu_phone === this.edit.model.stu_phone)){
                                                                callback(new Error("*该手机号已存在"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur",
                                                required: true
                                        }],
                                        stu_phone2: [{
                                                validator:(rule, value, callback) => {
                                                        if(value===null){
                                                                callback(new Error("*手机号不能为空"));
                                                        }else if(!/^1\d{10}$/.test(value)){
                                                                callback(new Error("*手机号格式错误"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur",
                                                required: true
                                        }],
                                        stu_name: [
                                                { required: true, message: '请填写学生姓名', trigger: 'blur' }
                                        ],
                                        stu_born: [
                                                {  required: true, message: '请选择日期', trigger: 'change' }
                                        ],
                                        stu_qualification:[
                                                { required: true, message: '请选择学历', trigger: 'change' }
                                        ],
                                        stu_address:[
                                                { required: true, message: '请填写家庭住址', trigger: 'blur' }
                                        ],
                                }
                        }
		},
	        computed:{
		        ...mapStateFromDictionary(["dictionary"]),//字典
                        ...mapGettersFromDictionary(["getGroupByKey"]),//学历
                        ...mapStateFromClasss(["classAll"]),//班级
	        },
	        methods:{
                        ...mapActionsFromClasss(['isClassAll']),
                        getPage(page){//改变页数
                                this.getStudentList.begin = (page - 1) * this.getStudentList.pageSize;
                                this.getAllData();
                        },
                        getSize(){//改变条数
                                this.getStudentList.begin = 0;
                                this.getAllData();
                        },
                        beforeAvatarUpload(file){//文件要求
                                const isJPG = file.type === 'image/jpeg';
                                const isPNG = file.type === 'image/png';
                                const isLt2M = file.size / 1024 / 1024 < 2;

                                if ((!isJPG)&&(!isPNG)) {
                                        this.$message.error('上传头像图片只能是 JPG 或者 PNG 格式!');
                                }
                                if (!isLt2M) {
                                        this.$message.error('上传头像图片大小不能超过 2MB!');
                                }
                                return (isJPG || isPNG) && isLt2M;
                        },
                        avatarUploadSuccess({ status,data,message },file,fileList){//上传成功以后的钩子函数
	                        //fileList不需要自己干预
				switch(status){
					case 200:
						this.upload.model.stu_avatar_new = data;
						if(fileList.length>1) fileList.shift();
						break;
					case 401:

					case 404:
					case 199:
					case 500:
					        this.$message.error(message)
				}
                        },
                        avatarRemove(file,fileList){//重置上传
                                this.upload.model.stu_avatar_new = "";
                        },
                        async saveAvatar(){//上传成功
                                let result = await this.$http({ url:"/student/avatarupdate" ,method:"post",data:this.upload.model});
                                this.$message({ message:"头像上传成功",type:"success" });
                                let i = this.studentAll.list.findIndex(item => item.stu_id === this.upload.model.stu_id);
                                this.studentAll.list[i].stu_avatar = result;
                                this.edit.isStudent=false;
	                        this.$refs.upload.clearFiles()
                        },
		        async getAllData(){//初始渲染数据
                                this.studentAll = await this.$http({ method:"post",url:"/student/list",data:this.getStudentList});
		        },
		        beginAdd(){//加
                                this.$refs.ruleForm && this.$refs.ruleForm.resetFields();
		                this.edit.isEdit = true;
                                this.edit.model.stu_name = null;
                                this.edit.model.stu_avatar = null;
                                this.edit.model.stu_cls_id = null;
                                this.edit.model.stu_sex = 1;
                                this.edit.model.stu_phone = null;
                                this.edit.model.stu_phone2 = null;
                                this.edit.model.stu_born = null;
                                this.edit.model.stu_qualification = null;
                                this.edit.model.stu_school = "";
                                this.edit.model.stu_major = "";
                                this.edit.model.stu_address = null;
                                this.edit.model.stu_remark = "";
                                this.edit.model.stu_id = null;
                                this.edit.isDialog = true;
		        },
		        beginEdit(node){//改
                                this.$refs.ruleForm && this.$refs.ruleForm.resetFields();
                                this.edit.isEdit = false;
                                this.edit.model.stu_name = node.stu_name;
                                this.edit.model.stu_avatar = node.stu_avatar;
                                this.edit.model.stu_cls_id = node.stu_cls_id;
                                this.edit.model.stu_sex = node.stu_sex;
                                this.edit.model.stu_phone = node.stu_phone;
                                this.edit.model.stu_phone2 = node.stu_phone2;
                                this.edit.model.stu_born = node.stu_born;
                                this.edit.model.stu_qualification = node.stu_qualification;
                                this.edit.model.stu_school = node.stu_school;
                                this.edit.model.stu_major = node.stu_major;
                                this.edit.model.stu_address = node.stu_address;
                                this.edit.model.stu_remark = node.stu_remark;
                                this.edit.model.stu_id = node.stu_id;
                                this.edit.isDialog = true;
		        },
		        saveStudent(){//存
                                this.$refs.ruleForm.validate(async valid => {
                                        if(!valid) return
                                        if(this.edit.isEdit){
                                                this.edit.model.stu_id = await this.$http({ url:"/student/add",method:"post",data:this.edit.model });
                                                this.studentAll.list.push(Object.assign({},this.edit.model));
                                                this.$message({ message:"学生信息添加成功" ,type:"success"});
                                        }else{
                                                await this.$http({ url:"/student/update",method:"post",data:this.edit.model });
                                                let i = this.studentAll.list.findIndex(item => item.stu_id === this.edit.model.stu_id)
                                                this.studentAll.list.splice(i,1,Object.assign({},this.edit.model));
                                                this.$message({ message:"学生信息修改成功" ,type:"success"});
                                        }
                                        this.edit.isDialog = false;
                                });
		        },
                        beginStudentGrouping(node){//准备单个分班
                                this.edit.isPiliang = true;
                                this.edit.model.stu_name = node.stu_name;
                                this.edit.model.stu_id = node.stu_id;
                                this.edit.model.stu_ids = node.stu_ids;
                                this.edit.model.stu_cls_id = node.stu_cls_id;
                               this.edit.isGrouping = true;
                        },
                        studentGrouping(){//分班
				this.$http({ url:"/student/assignclass" ,method:"post",data:this.edit.model });
				if(this.edit.isPiliang) {
                                        this.$message({ message:`"${this.edit.model.stu_name}"已分配班级` ,type:"success"});
                                        this.studentAll.list.find(item => item.stu_id === this.edit.model.stu_id).stu_cls_id = this.edit.model.stu_cls_id;
				}else{
                                        this.$message({ message:"批量分配成功" ,type:"success"});
					this.openClass.forEach(open => {
                                                this.studentAll.list.find(open2 => open2.stu_id == open).stu_cls_id = this.edit.model.stu_cls_id;
					})
				}
                                this.edit.isGrouping = false;
                        },
                        pushStudentAll(val){//数组
                                this.openClass=[];
                                val.forEach(items => {
                                        this.studentAll.list.forEach(item => {
                                                if( item.stu_id === items.stu_id){
                                                        this.openClass.push(item.stu_id)
                                                }
                                        })
                                });
				console.log(this.openClass);
                        },
		        beginMoreClass(node){//准备批量分班
			        if(this.openClass.length===0){
			                this.$message({ message:"请先勾选需要分班的学生",type:"warning" })
			        }else{
                                        this.edit.isPiliang = false;
                                        this.edit.model.stu_ids = this.openClass;
                                        this.edit.model.stu_cls_id = node.stu_cls_id;
                                        this.edit.isGrouping = true;
			        }
		        },
                        beginAvatar(node){
                                this.upload.model.stu_id = node.stu_id;
                                this.upload.model.stu_avatar_old = node.stu_avatar;
                                this.upload.model.stu_avatar_new = null;
                                this.edit.model.stu_avatar = node.stu_avatar;
                                this.edit.isStudent = true;
                        },
	        },
	        created(){
			this.getAllData();//初始获取所有数据
                        this.isClassAll();//班级信息
	        },
        }
</script>

<style lang="stylus" type="text/stylus" scoped>
	.el-header
		width 1460px
	.el-main
		.gory
			color: #999
		.blue
			color: #409EFF
			text-decoration underline
	.el-container
		/*background #F3F6F8*/
		position absolute
		left 0
		top 0
		width 100%
		height 100%
		.picClass
			display flex
			justify-content space-between
			p
				color: #f00
</style>