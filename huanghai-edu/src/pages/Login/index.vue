<template>
	<div class="body">
		<div class="logo-wrapper">
			<h1>黄海学院教学管理系统</h1>
		</div>
		<el-form :model="model" :rules="rules" status-icon ref="model">
			<h2>欢迎登录</h2>
			<el-form-item prop="user_name">
				<el-input suffix-icon="el-icon-s-custom"   v-model.trim="model.user_name" clearable>
					<template slot="prepend"><span class="prepend-text">用户名：</span></template>
				</el-input>
			</el-form-item>
			<el-form-item prop="user_pwd">
				<el-input suffix-icon="el-icon-lock" v-model.trim="model.user_pwd" show-password clearable>
					<template slot="prepend"><span class="prepend-text">密&emsp;码：</span></template>
				</el-input>
			</el-form-item>
			<el-form-item class="button-wrapper">
				<el-button plain @click="login('model')">登录</el-button>
			</el-form-item>
		</el-form>
	</div>
</template>

<script type="text/ecmascript-6">
        import ElForm from "../../../node_modules/element-ui/packages/form/src/form.vue";

        export default {
                components: {ElForm},
                name: "Login",
	        data(){
                        return {
                                model:{
                                        user_name: '',
                                        user_pwd: ''
                                },
                                rules: {
                                        user_name: [
                                                {required: true, message: '* 用户名不能为空',trigger:"blur"},
                                                {min: 3, max: 20,message: '用户名长度3-20位'}
                                        ],
                                        user_pwd: [
                                                {required: true, message: '密码不能为空',trigger:"blur"},
                                                {min: 3, max: 20,message: '密码长度3-20位'}
                                        ]
                                },
                        }
	        },
	        methods: {
//                        async  login(){
//                                let token = await this.$http({
//                                        url:"/user/login",
//                                        method:'post',
//                                        data:this.model
//                                });
//                                sessionStorage.setItem("token",token);
//                                sessionStorage.setItem('user_name', this.model.user_name);
//                                this.$router.replace('/home');
//                        }
                        login(formName) {
                                this.$refs[formName].validate((valid) => {
                                        if (valid) {
                                                let token = this.$http({
                                                        url: '/user/login',
                                                        method: 'post',
                                                        data: this.model,
                                                }).then(token => {
                                                        sessionStorage.setItem('token', token);
                                                        sessionStorage.setItem('user_name', this.model.user_name);
                                                        this.$router.replace('/home');
                                                });

                                        } else {
                                                console.log('error submit!!');
                                                return false;
                                        }
                                });
                        },
	        },
//                async
        }
</script>

<style lang="stylus" type="text/stylus" scoped>
	@keyframes aaa
		0% { transform:rotateY(0deg)}
		100% {transform:rotateY(30deg)}

	@keyframes bbb
		0%{transform:translateY(-50%) translateX(0%)}
		100%{transform:translateY(-50%) translateX(25%)}
	.body
		width 100%
		height: 100%
		background url("./denglubeijing1.jpg") no-repeat center center
		background-size cover
	.logo-wrapper
		perspective 500px
		position fixed
		top 50%
		right 50%
		transform translateY(-50%) translateX(0%)
		animation-name bbb
		animation-duration 1s
		animation-fill-mode forwards//保持结束动画，停留
		animation-delay 1s//延时一秒
		h1
			animation-name aaa
			animation-duration 1s
			animation-fill-mode forwards
			font-size 70px
			transform-origin left center
			transform  rotateY(30deg)
			text-shadow -10px 10px 10px black
			white-space nowrap
			padding 10px 50px
			color: #b0b0b0
			border-bottom 1px solid black
			/*&:before*/
				/*content: '黄海学院教学管理系统'*/
				/*position absolute*/
				/*left 0*/
				/*top 100%*/
				/*padding 30px 50px*/
				/*transform scaleY(-0.8)*/
	.el-form
		width: 300px
		border :1px solid #b0b0b0
		padding 50px 70px
		border-radius 8px
		position fixed
		top: 50%
		left: 55%
		transform translateY(-50%)
		box-shadow 0 0 15px 1px
		background rgba(255,255,255,.5)
		h2
			text-align center
			font-size 28px
			margin-bottom 20px
			color: #333
		span.prepend-text
			display flex
			width 50px
		.button-wrapper
			text-align center
</style>