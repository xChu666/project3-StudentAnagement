<template>
	<router-view></router-view>
	<!--   <router-view />   相当于  <router-view></router-view>  -->
</template>

<script type="text/ecmascript-6">
	//抽象出App根组件是一个很好的习惯，有的项目
	//根组件没什么用，有的项目根组件很有用，所以
	//都建议大家创建这个组件
	export default {
	        name: "App",

	}
</script>

<style>
	 /*当前项目相关的所有全局样式，适合放在这里来书写 */
	html,body{
		width:100%;
		height:100%;
	}
	 html{min-height: 600px;min-width: 1100px}
	/* 自定义的Element-ui样式 */
	 .el-input__validateIcon { color: #67c23a; font-weight: bold; }

	 /* 自定义树的样式 */
	 .custom-tree .el-tree-node { position: relative; padding-left: 16px; }
	 .custom-tree .el-tree-node__children { padding-left: 16px; }
	 .custom-tree .el-tree-node :last-child:before { height: 38px; }
	 .custom-tree .el-tree>.el-tree-node:before { border-left: none; }
	 .custom-tree-container .el-tree>.el-tree-node:after { border-top: none; }
	 .custom-tree .el-tree-node:before { content: ""; left: -4px; position: absolute; right: auto; border-width: 1px; }
	 .custom-tree .el-tree-node:after{ content: ""; left: -4px; position: absolute; right: auto; border-width: 1px; }
	 .custom-tree .el-tree-node__expand-icon.is-leaf { display: none; }
	 .custom-tree .el-tree-node:before { border-left: 1px dashed #b8b9bb; bottom: 0; height: 100%; top: -20px; width: 1px; }
	 .custom-tree .el-tree-node:after { border-top: 1px dashed #b8b9bb; height: 20px; top: 20px; width: 24px; }
	 .custom-tree .el-tree-node__content { height: 40px; }
	 .custom-tree .el-tree-node :last-child:before{ height: 0 }
	 .custom-tree .el-input__inner {width:300px}

	 /* el-tabs自定义样式 */
	 .el-tabs { height: 100%; display: flex; flex-direction: column; position: absolute; left: 0; top: 0; width: 100%; }
	 /* 父组件如何控制子组件内部渲染的元素的样式 */
	 .el-tabs >>> .el-tabs__header { flex-shrink: 0; }
	 .el-tabs /deep/ .el-tabs__content { flex-grow: 1; overflow: auto; }
	 .el-tab-pane { min-height: 100%; padding: 20px; box-sizing: border-box; }

	 /* el-dialog自定义样式 */
	 .el-dialog__wrapper { position: absolute; background-color: rgba(0,0,0, .5); }
	 .el-dialog { margin-top: 50px !important; }

	 /* 自定义el-drawer的样式 */
	 .custom-drawer.el-drawer__wrapper { position: absolute; background-color: rgba(0,0,0,0.5); }

	 /*自己搞的样式*/
	 /*.demo-input-suffix{display: flex}*/
	 /*.rolesclass {display: flex;flex-direction: column;height: 100%}*/
	 /*.rolesclass .el-input__inner{width: 200px}*/
	 /*.rolesclass .el-form{ display: flex; height: 40px}*/
	 /*.rolesclass .el-form-item__content{ display: flex ;margin-right: 10px}*/
	/*.rolesclass .el-pagination{justify-content:flex-end}*/
	/*.rolesclass .el-table{flex: 1}*/
	 .el-drawer{outline: none}
	.staffClass .el-dialog__body{height: 200px}
	 .staffClass .el-dialog__body .el-form-item{width: 100%}
	 .staffClass .el-dialog__body .el-form-item .el-textarea__inner{ width: 215px }
	 /*.staffClass .el-footer{ display: flex;align-items: center}*/
	 .staffClass .el-footer .el-pagination .el-pagination__rightwrapper{justify-content: flex-end}
	.el-main{background:#F3F6F8}
	 .custom-tree .el-tree-node { background: #F3F6F8 }
	 .el-tabs__nav-scroll{ background: #fff }
	 .displayTitle{display:flex; justify-content:space-between}

</style>