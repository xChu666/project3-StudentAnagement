<template>
	<el-container class="page-container">
		<el-aside :width="isCollapse?'65px':'230px'">
			<div class="toggle-button" @click="isCollapse = !isCollapse">
				<i class="el-icon-d-arrow-right" v-show="isCollapse"></i>
				<i class="el-icon-d-arrow-left" v-show="!isCollapse"></i>
				<span>MENU</span>
			</div>
			<el-menu background-color="#606162" text-color="#fff" active-text-color="#EB3941" uniqueOpened
			         :default-active="activeFuncKey" @select="menuSeleteHandler" :collapse="isCollapse" :collapse-transition="false"
			         show-timeout hide-timeout>
				<template v-for="item in menuData" >
					<el-menu-item v-if="item.func_key" :index="item.func_key" :key="item.func_id">
						<i class="el-icon-menu"></i>
						<span slot="title" v-text="item.func_name"></span>
					</el-menu-item>
					<el-submenu v-else :index="item.func_id.toString()" :key="item.func_id">
						<template slot="title">
							<i class="el-icon-setting"></i>
							<span slot="title" v-text="item.func_name"></span>
						</template>
						<template v-if="item.children">
							<el-menu-item v-for="item2 in item.children" :index="item2.func_key" :key="item2.func_id">
								<i class="el-icon-menu"></i>
								<span slot="title" v-text="item2.func_name"></span>
							</el-menu-item>
						</template>
					</el-submenu>
				</template>
			</el-menu>
		</el-aside>
		<!--<el-container>-->
		<el-container>
			<el-header height="70px">
				<div class="avatar-wrapper">
					<el-avatar :size="50" src="/images/student/999999.jpg"></el-avatar>
					<h1>黄海学院学生管理系统 V1.0</h1>
				</div>
				<el-row>
					<span>欢迎您</span><span v-text="''+ ' ' + userName+ ' ' "  class="userName"></span>
					<el-button type="info" plain @click="dropOut">退出</el-button>
				</el-row>
			</el-header>
			<el-main>
				<el-tabs type="card" closable  v-model="activeFuncKey" @tab-remove="tabRemoveHandler">
					<el-tab-pane v-for="func_key in activeFuncKeys" :key="func_key"
					             :label="menu.find( item => item.func_key === func_key ).func_name"
					             :name="func_key">
						<complate :is="views[func_key]"></complate>
					</el-tab-pane>
				</el-tabs>
			</el-main>
			<el-footer>
				版权所有© 2020 小褚，All rights reserved.
			</el-footer>
		</el-container>
		<!--</el-container>-->
	</el-container>
</template>

<script type="text/ecmascript-6">
        import views from '../../views';
        import { createNamespacedHelpers } from "vuex";
        var { mapActions:mapActionsFromDictionary } = createNamespacedHelpers("dictionary");
        export default {
                name: "Home",
                data(){
                        return{
                                isCollapse:true,//展开还是折叠
                                views,
                                activeFuncKey: "",
                                activeFuncKeys: [],
                                menu:[],
	                        userName:sessionStorage.getItem('user_name'),
                        };

                },
                computed:{
                        menuData(){
                                let result = [];
                                this.menu.filter( item => item.func_fid === 0 ).forEach( item => {
                                        let node = Object.assign({} , item);
                                        let children = this.menu.filter( item2 => item2.func_fid === item.func_id );
                                        if( children.length > 0 ){
                                                node.children = [];
                                                children.forEach( item2 => node.children.push(Object.assign({}, item2)));
                                        }
                                        result.push(node);
                                } );
                                return result;
                        }
                },
                methods:{
	                ...mapActionsFromDictionary(["dictionaryInit"]),
                        dropOut(){
                                sessionStorage.clear();
                                this.$router.push("/login")
                        }
                        ,
                        menuSeleteHandler( index,indexPath ){
                                this.activeFuncKey = index;
                                if( this.activeFuncKeys.indexOf( index ) === -1 ){
                                        this.activeFuncKeys.push(index);
                                }
                        },
                        tabRemoveHandler( name ){
                                this.activeFuncKeys.splice( this.activeFuncKeys.indexOf(name) ,1 );
                                if( this.activeFuncKeys.indexOf(this.activeFuncKey) === -1 ){
                                        this.activeFuncKey = this.activeFuncKeys[0] || "";
                                }
                        },
                },
	        async created(){
                        this.dictionaryInit();
                        this.menu = await this.$http({
	                        url: "/user/getmenu",
	                        method: "post"
                        });
	        }
        }
</script>

<style lang="stylus" type="text/stylus" scoped>
	.page-container
		height: 100%
		.toggle-button
			height 40px
			background #606162
			font-size 20px
			line-height 40px
			color: #fff
			letter-spacing 0.2em
			cursor: pointer
			margin-left 23px
			overflow hidden
			span
				margin-left 20px

		.el-header
			display: flex
			align-items: center
			justify-content space-between
			background-color: #303133
			color: #fff
			h1
				font-size: 32px
				margin-left 10px
		.el-aside
			background-color: #606162
			.el-menu
				border-right: none
		.el-footer
			background-color: #909399
			display flex
			align-items flex-end
			justify-content center
			color #fff
		.el-main
			position relative
		.userName
			color: #f00
		.avatar-wrapper
			display flex
</style>