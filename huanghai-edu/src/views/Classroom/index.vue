<template>
	<div>
		<div class="color">
			<p class="colorUsed" ></p><span>使用中</span><p class="colorSky"></p><span>空闲中</span>
		</div>
		<el-row :gutter="20">
			<el-col :span="6" v-for="item in classRoomList" :key="item.clsr_id">
				<el-card shadow="hover" :class="{is_used: item.clsr_occupy === 1}">
					<span v-text="item.clsr_name"></span>
					<div class="button-wrapper">
						<el-button type="text" @click="beginEditRoom(item)"><i class="el-icon-edit-outline"></i></el-button>
						<el-button type="text" @click="removeRoom(item.clsr_id)" v-if="item.clsr_occupy === 0"><i class="el-icon-delete"></i></el-button>
					</div>
				</el-card>
			</el-col>
			<el-col :span="6">
				<el-card class="btn-add" shadow="hover" @click.native="beginAddRoom"><i class="el-icon-plus"></i></el-card>
			</el-col>
		</el-row>
		<!-- 弹框 -->
		<el-dialog :modal="false" :title="room.isEdit === true?'新增教室信息':'编辑教室信息'" :visible.sync="room.isDialog"  width="550px" >
			<el-form :model="room.model" :rules="rules" ref="form">
				<el-form-item prop="clsr_name">
					<el-input placeholder="请输入需要的教室名称"  v-model.trim="room.model.clsr_name" clearable></el-input>
				</el-form-item>
			</el-form>
			<span slot="footer">
				    <el-button type="primary"  v-text="room.isEdit === true? '确定':'保存'" @click="saveRoom"></el-button>
				    <el-button @click="room.isDialog = false">取 消</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script type="text/ecmascript-6">
	import { createNamespacedHelpers } from "vuex";
	let { mapState:mapStateFromClassRoom,mapActions:mapActionsFromClassRoom } = createNamespacedHelpers("classroom")
        export default {
                name: "Classroom",
	        data(){
                        return {
				room:{
                                        isEdit:true,//编辑还是新增
					isDialog:false,//弹框关闭开启
                                        model:{ clsr_id:"", clsr_name:"",clsr_occupy :0}
				},
                                rules:{
                                        clsr_name: [{
                                                validator:(rule, value, callback) => {
                                                        if(value.length === 0){
                                                                callback(new Error("*教室名称不能为空"));
                                                        }else if(value.length < 2 || value.length > 10){
                                                                callback(new Error("*教室名称长度2-10"));
                                                        }else if(this.classRoomList.some(item => item.clsr_id !== this.room.model.clsr_id && item.clsr_name === this.room.model.clsr_name)){
                                                                callback(new Error("*教室已存在"));
                                                        }else{
                                                                callback();
                                                        }
                                                },
                                                trigger: "blur"
                                        }]
                                }
                        }
	        },
	        async created(){
			this.isUsedClass();
	        },
	        computed:{
		        ...mapStateFromClassRoom(["classRoomList"]),
	        },
	        methods:{
		        ...mapActionsFromClassRoom(["isUsedClass","addClassRoom","editClassRoom","removeClassRoom"]),
		        //删除
                        removeRoom(clsr_id){
				this.$confirm("确认删除该教室？","警告",{
                                        confirmButtonText: '确定',
                                        cancelButtonText: '取消',
                                        type: 'warning'
				})
					.then(async () => {
						await this.removeClassRoom(clsr_id);
						this.$message({ message:"删除成功",type:"success" })
					})
                        },
		        //开始新增
                        beginAddRoom(){
                                this.$refs.form && this.$refs.form.resetFields();
                                this.room.isEdit = true
                                this.room.model.clsr_name = "";
                                this.room.isDialog = true;
		        },
		        //开始编辑
		        beginEditRoom(node){
                                this.$refs.form && this.$refs.form.resetFields();
                                this.room.isEdit = false
                                this.room.model.clsr_id = node.clsr_id;
                                this.room.model.clsr_name = node.clsr_name;
                                this.room.model.clsr_occupy = node.clsr_occupy;
                                this.room.isDialog = true;
                        },
		        //保存
                        saveRoom(){
                                this.$refs.form.validate(async valid =>{
                                        if(!valid) return;
                                        if(this.room.isEdit){
                                                await this.addClassRoom(Object.assign({},this.room.model))
                                        }else{
                                                await this.editClassRoom(Object.assign({},this.room.model))
                                        }
                                        this.room.isDialog = false;
                                })
                        }
	        }
        }
</script>

<style lang="stylus" type="text/stylus" scoped>
	.el-col
		margin-bottom 30px
		.el-card
			text-align center
			padding 10%
			background #0f0
			color: #fff
			font-weight bold
			font-size 24px
			cursor pointer
			position: relative
			&.btn-add
				background transparent
				border 1px dashed #0f0
				color #99e
				font-weight bold
			.button-wrapper
				position absolute
				right 10px
				bottom 0
				.el-button
					font-size 20px
					color: #fff
	.el-col
		.is_used
			background #f00
	.color
		display flex
		margin-bottom 10px
		p,span
			margin-right 5px
		.colorUsed
			background #f00
			width 20px
			height:20px
		.colorSky
			background #0f0
			width 20px
			height:20px
</style>